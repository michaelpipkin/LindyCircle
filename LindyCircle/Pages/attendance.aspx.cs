using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class attendance : Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            RegisterPostBackControls();
            if (!IsPostBack) {
                ddlPaymentTypes.Items.Add(new ListItem("None", "0"));
                ddlPaymentTypes.Items.Add(new ListItem("Door price", "1"));
                ddlPaymentTypes.Items.Add(new ListItem("Punch card", "2"));
                ddlPaymentTypes.Items.Add(new ListItem("Other", "3"));
            }
        }

        protected void txtPracticeDate_TextChanged(object sender, EventArgs e) {
            lblSaveStatus.Text = string.Empty;
            DateTime practiceDate;
            if (DateTime.TryParse(txtPracticeDate.Text, out practiceDate)) {
                calPracticeDate.SelectedDate = practiceDate;
                GetPracticeID(practiceDate);
            }
        }

        protected void calPracticeDate_SelectionChanged(object sender, EventArgs e) {
            lblSaveStatus.Text = string.Empty;
            txtPracticeDate.Text = calPracticeDate.SelectedDate.ToShortDateString();
            GetPracticeID(calPracticeDate.SelectedDate);
        }

        protected void GetPracticeID(DateTime practiceDate) {
            using (var db = new LindyCircleContext()) {
                var practice = db.Practices.SingleOrDefault(t => t.PracticeDate == practiceDate);
                if (practice != null) {
                    hidPracticeID.Value = practice.PracticeID.ToString();
                    txtPracticeNumber.Text = practice.PracticeNumber.ToString();
                    txtTopic.Text = practice.PracticeTopic;
                    txtRentalCost.Text = practice.PracticeCost.ToString("0.00");
                    txtMiscExpense.Text = practice.MiscExpense.ToString("0.00");
                    txtMiscRevenue.Text = practice.MiscRevenue.ToString("0.00");
                    panPracticeDetails.Visible = true;
                    panPracticeMembers.Visible = true;
                    btnAddPractice.Visible = false;
                    btnCancelAddPractice.Visible = false;
                    btnSaveDetails.Visible = true;
                    lblNewPractice.Text = string.Empty;
                    lblSaveStatus.Text = string.Empty;
                }
                else {
                    hidPracticeID.Value = null;
                    panPracticeDetails.Visible = true;
                    panPracticeMembers.Visible = false;
                    btnAddPractice.Visible = true;
                    btnCancelAddPractice.Visible = true;
                    btnSaveDetails.Visible = false;
                    lblNewPractice.Text = "Would you like to add a new practice dated " +
                        calPracticeDate.SelectedDate.ToShortDateString() + "?";
                    txtPracticeNumber.Text = (db.Practices.Max(t => t.PracticeNumber) + 1).ToString();
                    txtTopic.Text = string.Empty;
                    txtRentalCost.Text = db.Defaults.Single(t => t.DefaultName.Equals("Rental Cost")).
                        DefaultValue.ToString("0.00");
                    txtMiscExpense.Text = "0.00";
                    txtMiscRevenue.Text = "0.00";
                    lblSaveStatus.Text = string.Empty;
                }
            }
        }

        protected void ddlPaymentTypes_SelectedIndexChanged(object sender, EventArgs e) {
            SetDefaultPaymentAmount();
        }

        protected void btnAddPractice_Click(object sender, EventArgs e) {
            if (Page.IsValid) {
                using (var db = new LindyCircleContext()) {
                    var practice = new Practice
                    {
                        PracticeNumber = int.Parse(txtPracticeNumber.Text),
                        PracticeDate = calPracticeDate.SelectedDate,
                        PracticeTopic = txtTopic.Text
                    };
                    if (string.IsNullOrEmpty(txtRentalCost.Text)) practice.PracticeCost = 0M;
                    else practice.PracticeCost = decimal.Parse(txtRentalCost.Text);
                    if (string.IsNullOrEmpty(txtMiscExpense.Text)) practice.MiscExpense = 0M;
                    else practice.MiscExpense = decimal.Parse(txtMiscExpense.Text);
                    if (string.IsNullOrEmpty(txtMiscRevenue.Text)) practice.MiscRevenue = 0M;
                    else practice.MiscRevenue = decimal.Parse(txtMiscRevenue.Text);
                    db.Practices.Add(practice);
                    db.SaveChanges();
                    hidPracticeID.Value = db.Practices.Max(t => t.PracticeID).ToString();
                    btnAddPractice.Visible = false;
                    btnCancelAddPractice.Visible = false;
                    btnSaveDetails.Visible = true;
                    panPracticeMembers.Visible = true;
                    lblNewPractice.Text = string.Empty;
                    lblSaveStatus.Text = string.Empty;
                }
            }
        }

        protected void btnCancelAddPractice_Click(object sender, EventArgs e) {
            panPracticeDetails.Visible = false;
            txtPracticeDate.Text = string.Empty;
        }

        protected void ddlMembers_SelectedIndexChanged(object sender, EventArgs e) {
            SetDefaultPaymentType();
        }

        protected void ddlMembers_DataBound(object sender, EventArgs e) {
            SetDefaultPaymentType();
        }

        protected void SetDefaultPaymentType() {
            var selectedMemberID = int.Parse(ddlMembers.SelectedValue);
            using (var db = new LindyCircleContext()) {
                var unusedPunches = db.Members.Single(t => t.MemberID == selectedMemberID).RemainingPunches;
                lblUnusedPunches.Text = unusedPunches.ToString();
                if (unusedPunches >= 1)
                    ddlPaymentTypes.SelectedIndex = 2;
                else ddlPaymentTypes.SelectedIndex = 1;
            }
            SetDefaultPaymentAmount();
        }

        protected void SetDefaultPaymentAmount() {
            if (ddlPaymentTypes.SelectedValue.Equals("1")) {
                using (var db = new LindyCircleContext())
                    txtPaymentAmount.Text = db.Defaults.Single(t => t.DefaultName.Equals("Door price")).
                        DefaultValue.ToString("0.00");
            }
            else txtPaymentAmount.Text = "0.00";
        }

        protected void btnCheckIn_Click(object sender, EventArgs e) {
            if (Page.IsValid) {
                int attendanceID, memberID, practiceID, paymentType;
                memberID = int.Parse(ddlMembers.SelectedValue);
                practiceID = int.Parse(hidPracticeID.Value);
                paymentType = int.Parse(ddlPaymentTypes.SelectedValue);
                var attendance = new Attendance
                {
                    MemberID = memberID,
                    PracticeID = practiceID,
                    PaymentType = paymentType
                };
                if (string.IsNullOrEmpty(txtPaymentAmount.Text)) attendance.PaymentAmount = 0M;
                else attendance.PaymentAmount = decimal.Parse(txtPaymentAmount.Text);
                using (var db = new LindyCircleContext()) {
                    db.Attendances.Add(attendance);
                    db.SaveChanges();
                    if (paymentType == 2) {
                        attendanceID = db.Attendances.Single(t => t.MemberID == memberID && t.PracticeID == practiceID).AttendanceID;
                        var punchCardUsage = new PunchCardUsage
                        {
                            AttendanceID = attendanceID,
                            PunchCardID = db.Members.Single(t => t.MemberID == memberID).PunchCardsHeld.First(t => t.RemainingPunches > 0).PunchCardID
                        };
                        db.PunchCardUsages.Add(punchCardUsage);
                        db.SaveChanges();
                    }
                }
                gvAttendance.DataBind();
            }
        }


        protected void btnSaveDetails_Click(object sender, EventArgs e) {
            if (Page.IsValid) {
                using (var db = new LindyCircleContext()) {
                    var practiceID = int.Parse(hidPracticeID.Value);
                    var practice = db.Practices.Single(t => t.PracticeID == practiceID);
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

        protected void RegisterPostBackControls() {
            foreach (GridViewRow row in gvAttendance.Rows) {
                LinkButton lb = row.FindControl("btnRemove") as LinkButton;
                ScriptManager.GetCurrent(this).RegisterAsyncPostBackControl(lb);
            }
        }

        protected void valPracticeNumberUnique_ServerValidate(object source, ServerValidateEventArgs args) {
            var practiceNumber = int.Parse(txtPracticeNumber.Text);
            using (var db = new LindyCircleContext()) {
                var practice = db.Practices.SingleOrDefault(t => t.PracticeNumber == practiceNumber);
                if (hidPracticeID.Value == null)
                    args.IsValid = practice == null;
                else {
                    var practiceID = int.Parse(hidPracticeID.Value);
                    args.IsValid = (practice == null || practice.PracticeID == practiceID);
                }
            }
        }

        protected void gvAttendance_DataBound(object sender, EventArgs e) {
            var attendance = 0;
            var totalCollected = 0M;
            foreach (GridViewRow row in gvAttendance.Rows) {
                if (row.RowType == DataControlRowType.DataRow) {
                    attendance++;
                    totalCollected += decimal.Parse(row.Cells[4].Text);
                }
                gvAttendance.FooterRow.Cells[1].Text = "Attended: " + attendance.ToString();
                gvAttendance.FooterRow.Cells[4].Text = totalCollected.ToString("#,##0.00");
            }
            ddlMembers.DataBind();
        }

        protected void valPunchesRemaining_ServerValidate(object source, ServerValidateEventArgs args) {
            if (ddlPaymentTypes.SelectedValue.Equals("2")) {
                var memberID = int.Parse(ddlMembers.SelectedValue);
                using (var db = new LindyCircleContext()) {
                    args.IsValid = db.Members.Single(t => t.MemberID == memberID).RemainingPunches > 0;
                }
            }
        }
    }
}