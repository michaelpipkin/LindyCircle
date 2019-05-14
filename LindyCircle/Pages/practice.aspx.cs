using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class practice : Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) {
                int practiceID;
                if (int.TryParse(Page.RouteData.Values["practiceID"].ToString(), out practiceID)) {
                    using (var db = new LindyCircleContext()) {
                        var practice = db.Practices.SingleOrDefault(t => t.PracticeID == practiceID);
                        if (practice != null) {
                            txtPracticeNumber.Text = practice.PracticeNumber.ToString();
                            lblPracticeDate.Text = practice.PracticeDate.ToShortDateString();
                            txtTopic.Text = practice.PracticeTopic;
                            txtRentalCost.Text = practice.PracticeCost.ToString("#,##0.00");
                            txtMiscExpense.Text = practice.MiscExpense.ToString("#,##0.00");
                            txtMiscRevenue.Text = practice.MiscRevenue.ToString("#,##0.00");
                        }
                        else Response.Redirect("~/practices", true);
                    }
                }
                else Response.Redirect("~/practices", true);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e) {
            if (Page.IsValid) {
            var practiceID = int.Parse(Page.RouteData.Values["practiceID"].ToString());
                using (var db = new LindyCircleContext()) {
                    var practice = db.Practices.Single(t => t.PracticeID == practiceID);
                    practice.PracticeNumber = int.Parse(txtPracticeNumber.Text);
                    practice.PracticeTopic = txtTopic.Text;
                    if (string.IsNullOrEmpty(txtRentalCost.Text)) practice.PracticeCost = 0M;
                    else practice.PracticeCost = decimal.Parse(txtRentalCost.Text);
                    if (string.IsNullOrEmpty(txtMiscExpense.Text)) practice.MiscExpense = 0M;
                    else practice.MiscExpense = decimal.Parse(txtMiscExpense.Text);
                    if (string.IsNullOrEmpty(txtMiscRevenue.Text)) practice.MiscRevenue = 0M;
                    else practice.MiscRevenue = decimal.Parse(txtMiscRevenue.Text);
                    db.SaveChanges();
                    lblSaveStatus.Text = "Practice details updated.";
                }
            }
        }

        protected void valPracticeNumberUnique_ServerValidate(object source, ServerValidateEventArgs args) {
            var practiceID = int.Parse(Page.RouteData.Values["practiceID"].ToString());
            var practiceNumber = int.Parse(txtPracticeNumber.Text);
            using (var db = new LindyCircleContext()) {
                var practice = db.Practices.SingleOrDefault(t => t.PracticeNumber == practiceNumber);
                args.IsValid = (practice == null || practice.PracticeID == practiceID);
            }
        }
    }
}