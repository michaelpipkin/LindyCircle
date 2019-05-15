using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class punchcards : Page
    {
        decimal punchCardCost = 0M;

        protected void Page_Init(object sender, EventArgs e) {
            using (var db = new LindyCircleContext())
                punchCardCost = db.Defaults.Single(t => t.DefaultName.Equals("Punch card price")).DefaultValue;
        }

        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) {
                txtPurchaseDate.Text = DateTime.Now.ToShortDateString();
                txtAmount.Text = punchCardCost.ToString("0.00");
            }
            RegisterPostBackControls();
        }

        protected void btnPurchase_Click(object sender, EventArgs e) {
            var punchCard = new PunchCard();
            punchCard.MemberID = int.Parse(ddlMembers.SelectedValue);
            punchCard.PurchaseDate = DateTime.Parse(txtPurchaseDate.Text);
            punchCard.PurchaseAmount = decimal.Parse(txtAmount.Text);
            using (var db = new LindyCircleContext()) {
                db.PunchCards.Add(punchCard);
                db.SaveChanges();
                txtPurchaseDate.Text = DateTime.Now.ToShortDateString();
                txtAmount.Text = punchCardCost.ToString("0.00");
                gvPunchCards.DataBind();
            }
        }

        protected void RegisterPostBackControls() {
            foreach (GridViewRow row in gvPunchCards.Rows) {
                LinkButton lb = row.FindControl("btnDelete") as LinkButton;
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(lb);
            }
        }

        protected void ddlMembers_DataBound(object sender, EventArgs e) {
            gvPunchCards.DataBind();
            UpdateUnusedPunches();
        }

        protected void ddlMembers_SelectedIndexChanged(object sender, EventArgs e) {
            UpdateUnusedPunches();
        }

        protected void UpdateUnusedPunches() {
            if (ddlMembers.SelectedIndex > -1) {
                using (var db = new LindyCircleContext()) {
                    var memberID = int.Parse(ddlMembers.SelectedValue);
                    lblUnusedPunches.Text = db.Members.Single(t => t.MemberID == memberID).RemainingPunches.ToString();
                }
            }
        }

        protected void gvPunchCards_DataBound(object sender, EventArgs e) {
            lblWarning.Text = string.Empty;
            UpdateUnusedPunches();
            if (gvPunchCards.Rows.Count > 0) {
                var punchCardCount = 0;
                var punchCardTotal = 0M;
                foreach (GridViewRow row in gvPunchCards.Rows) {
                    if (row.RowType == DataControlRowType.DataRow) {
                        punchCardCount++;
                        punchCardTotal += decimal.Parse(row.Cells[2].Text);
                    }
                }
                gvPunchCards.FooterRow.Cells[1].Text = "Total: " + punchCardCount.ToString();
                gvPunchCards.FooterRow.Cells[2].Text = punchCardTotal.ToString("#,##0.00");
            }
        }

        protected void gvPunchCards_RowDeleting(object sender, GridViewDeleteEventArgs e) {
            var memberID = int.Parse(ddlMembers.SelectedValue);
            using (var db = new LindyCircleContext()) {
                var member = db.Members.Single(t => t.MemberID == memberID);
                if (member.RemainingPunches < 5) {
                    lblWarning.Text = "Unable to delete punch card - not enough punches remaining.";
                    e.Cancel = true;
                }
            }
        }
    }
}