using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace LindyCircle.Pages
{
    public partial class finances : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void btnReset_Click(object sender, EventArgs e) {
            txtStartDate.Text = string.Empty;
            txtEndDate.Text = string.Empty;
        }

        protected void gvFinances_DataBound(object sender, EventArgs e) {
            var rentalCostTotal = 0M;
            var admissionsTotal = 0M;
            var miscExpenseTotal = 0M;
            var miscRevenueTotal = 0M;
            var punchCardsSoldTotal = 0;
            var punchCardRevenueTotal = 0M;
            var lineTotal = 0M;
            foreach (GridViewRow row in gvFinances.Rows) {
                if (row.RowType == DataControlRowType.DataRow) {
                    rentalCostTotal += decimal.Parse(row.Cells[1].Text);
                    admissionsTotal += decimal.Parse(row.Cells[2].Text);
                    miscExpenseTotal += decimal.Parse(row.Cells[3].Text);
                    miscRevenueTotal += decimal.Parse(row.Cells[4].Text);
                    punchCardsSoldTotal += int.Parse(row.Cells[5].Text);
                    punchCardRevenueTotal += decimal.Parse(row.Cells[6].Text);
                    lineTotal += decimal.Parse(row.Cells[7].Text);
                }
            }
            gvFinances.FooterRow.Cells[1].Text = rentalCostTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[2].Text = admissionsTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[3].Text = miscExpenseTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[4].Text = miscRevenueTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[5].Text = punchCardsSoldTotal.ToString("0");
            gvFinances.FooterRow.Cells[6].Text = punchCardRevenueTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[7].Text = lineTotal.ToString("#,##0.00");
            gvFinances.FooterRow.Cells[8].Text = lineTotal.ToString("#,##0.00");
        }
    }
}