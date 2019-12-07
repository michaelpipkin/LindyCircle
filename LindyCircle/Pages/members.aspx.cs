using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class members : Page
    {
        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void btnNew_Click(object sender, EventArgs e) {
            var member = new Member
            {
                FirstName = txtFirstName.Text,
                LastName = txtLastName.Text,
                Inactive = false
            };
            using (var db = new LindyCircleContext()) {
                if (db.Members.FirstOrDefault(t => t.FirstName == member.FirstName && t.LastName == member.LastName) == null) {
                    db.Members.Add(member);
                    db.SaveChanges();
                    txtFirstName.Text = string.Empty;
                    txtLastName.Text = string.Empty;
                    gvMembers.DataBind();
                }
                else lblWarning.Text = "A member with this first and last name already exists.";
            }
        }

        protected void ckbInactive_CheckedChanged(object sender, EventArgs e) {
            var checkbox = (CheckBox)sender;
            var row = (GridViewRow)checkbox.Parent.Parent;
            var memberID = (int)gvMembers.DataKeys[row.RowIndex].Value;
            using (var db = new LindyCircleContext()) {
                var member = db.Members.Single(t => t.MemberID == memberID);
                member.Inactive = checkbox.Checked;
                db.SaveChanges();
                gvMembers.DataBind();
            }
        }
    }
}