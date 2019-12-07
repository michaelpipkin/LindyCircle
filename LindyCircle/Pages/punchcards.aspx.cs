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
            var punchCard = new PunchCard
            {
                PurchaseMemberID = int.Parse(ddlMembers.SelectedValue),
                CurrentMemberID = int.Parse(ddlMembers.SelectedValue),
                PurchaseDate = DateTime.Parse(txtPurchaseDate.Text),
                PurchaseAmount = decimal.Parse(txtAmount.Text)
            };
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
                var remainingPunchesTotal = 0;
                foreach (GridViewRow row in gvPunchCards.Rows) {
                    if (row.RowType == DataControlRowType.DataRow) {
                        punchCardCount++;
                        punchCardTotal += decimal.Parse(row.Cells[2].Text);
                        remainingPunchesTotal += int.Parse(row.Cells[3].Text);
                    }
                }
                gvPunchCards.FooterRow.Cells[1].Text = "Total: " + punchCardCount.ToString();
                gvPunchCards.FooterRow.Cells[2].Text = punchCardTotal.ToString("#,##0.00");
                gvPunchCards.FooterRow.Cells[3].Text = remainingPunchesTotal.ToString("0");
            }
        }

        protected void gvPunchCards_RowDeleting(object sender, GridViewDeleteEventArgs e) {
            var punchCardID = (int)gvPunchCards.DataKeys[e.RowIndex].Value;
            using (var db = new LindyCircleContext()) {
                var punchCard = db.PunchCards.Single(t => t.PunchCardID == punchCardID);
                if (punchCard.RemainingPunches < 5) {
                    lblWarning.Text = "Unable to delete used punch card.";
                    e.Cancel = true;
                }
            }
        }

        protected void gvPunchCards_RowCommand(object sender, GridViewCommandEventArgs e) {
            if (e.CommandName.Equals("Transfer")) {
                var punchCardID = int.Parse(e.CommandArgument.ToString());
                using (var db = new LindyCircleContext()) {
                    var punchCard = db.PunchCards.Single(t => t.PunchCardID == punchCardID);
                    if (punchCard.RemainingPunches == 0)
                        lblWarning.Text = "Unable to transfer punch card with no punches remaining.";
                    else {
                        hidPunchCardID.Value = punchCardID.ToString();
                        lblTransferText.Text = string.Format("Transfer {0} unused punches to ", punchCard.RemainingPunches);
                        gvPunchCards.Visible = false;
                        ddlMembers.Enabled = false;
                        btnPurchase.Enabled = false;
                        pnlTransfer.Visible = true;
                        lblWarning.Text = string.Empty;
                    }
                }
            }
        }

        protected void btnTransfer_Click(object sender, EventArgs e) {
            if (ddlMembers.SelectedValue == ddlTransferMember.SelectedValue)
                lblWarning.Text = "Cannot transfer punch card to the same member.";
            else {
                var punchCardID = int.Parse(hidPunchCardID.Value);
                using (var db = new LindyCircleContext()) {
                    var punchCard = db.PunchCards.Single(t => t.PunchCardID == punchCardID);
                    punchCard.CurrentMemberID = int.Parse(ddlTransferMember.SelectedValue);
                    db.SaveChanges();
                    gvPunchCards.DataBind();
                    gvPunchCards.Visible = true;
                    pnlTransfer.Visible = false;
                    ddlMembers.Enabled = true;
                    btnPurchase.Enabled = true;
                    lblWarning.Text = string.Empty;
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e) {
            gvPunchCards.Visible = true;
            pnlTransfer.Visible = false;
            ddlMembers.Enabled = true;
            btnPurchase.Enabled = true;
            hidPunchCardID.Value = null;
            lblWarning.Text = string.Empty;
        }
    }
}