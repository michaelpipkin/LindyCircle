using System;

namespace LindyCircle.Pages
{
    public partial class history : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {
            txtStartDate.Text = new DateTime(DateTime.Now.Year, 1, 1).ToShortDateString();
        }

        protected void btnReset_Click(object sender, EventArgs e) {
            txtStartDate.Text = string.Empty;
            txtEndDate.Text = string.Empty;
        }
    }
}