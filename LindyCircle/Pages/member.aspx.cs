using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class member : Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) {
                int memberID;
                if (int.TryParse(Page.RouteData.Values["memberID"].ToString(), out memberID)) {
                    using (var db = new LindyCircleContext()) {
                        var member = db.Members.SingleOrDefault(t => t.MemberID == memberID);
                        if (member != null) lblMemberName.Text = member.FirstLastName;
                        else Response.Redirect("~/members", true);
                    }
                }
                else Response.Redirect("~/members", true);
            }
        }

        protected void gvHistory_DataBound(object sender, EventArgs e) {
            var practiceCount = 0;
            var totalPaid = 0M;
            foreach (GridViewRow row in gvHistory.Rows) {
                if (row.RowType == DataControlRowType.DataRow) {
                    practiceCount++;
                    totalPaid += decimal.Parse(row.Cells[2].Text);
                }
            }
            gvHistory.FooterRow.Cells[1].Text = practiceCount.ToString();
            gvHistory.FooterRow.Cells[2].Text = totalPaid.ToString("#,##0.00");
        }
    }
}