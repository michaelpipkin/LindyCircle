using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class history : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void btnReset_Click(object sender, EventArgs e) {
            txtStartDate.Text = string.Empty;
            txtEndDate.Text = string.Empty;
        }
    }
}