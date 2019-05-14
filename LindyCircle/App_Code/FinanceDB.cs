using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;

namespace LindyCircle
{
    [DataObject(true)]
    public class FinanceDB
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetFinancialData(DateTime? startDate, DateTime? endDate) {
            var dt = new DataTable();
            dt.Columns.Add("PreviousPracticeDate", typeof(DateTime));
            dt.Columns.Add("PracticeID", typeof(int));
            dt.Columns.Add("PracticeDate", typeof(DateTime));
            dt.Columns.Add("RentalCost", typeof(decimal));
            dt.Columns.Add("AdmissionRevenue", typeof(decimal));
            dt.Columns.Add("MiscExpense", typeof(decimal));
            dt.Columns.Add("MiscRevenue", typeof(decimal));
            dt.Columns.Add("PunchCardsSold", typeof(int));
            dt.Columns.Add("PunchCardRevenue", typeof(decimal));
            dt.Columns.Add("TotalExpenseRevenue", typeof(decimal));
            dt.Columns.Add("RunningTotal", typeof(decimal));
            using (var db = new LindyCircleContext()) {
                if (startDate == null)
                    startDate = db.Practices.Min(t => t.PracticeDate);
                if (endDate == null)
                    endDate = db.Practices.Max(t => t.PracticeDate);
                var query = from t in db.Practices
                            where t.PracticeDate >= startDate && t.PracticeDate <= endDate
                            orderby t.PracticeDate ascending
                            select t;
                foreach (var row in query) {
                    dt.Rows.Add(null, row.PracticeID, row.PracticeDate, row.PracticeCost,
                        row.Attendances.Sum(t => t.PaymentAmount), row.MiscExpense,
                        row.MiscRevenue, 0, 0M, 0M, 0M);
                }
                var runningTotal = 0M;
                for (int i = 0; i < dt.Rows.Count; i++) {
                    var practiceDate = DateTime.Parse(dt.Rows[i]["PracticeDate"].ToString());
                    var punchCards = new List<PunchCard>();
                    if (i == 0) {
                        var previousPractices = db.Practices.Where(t => t.PracticeDate < practiceDate);
                        if (previousPractices.Count() > 0) {
                            var previousDate = previousPractices.Max(t => t.PracticeDate);
                            dt.Rows[i]["PreviousPracticeDate"] = previousDate;
                            punchCards = db.PunchCards.Where(t => t.PurchaseDate <= practiceDate &&
                            t.PurchaseDate > previousDate).ToList();
                        }
                        else punchCards = db.PunchCards.Where(t => t.PurchaseDate <= practiceDate).ToList();
                    }
                    else {
                        var previousDate = DateTime.Parse(dt.Rows[i - 1]["PracticeDate"].ToString());
                        dt.Rows[i]["PreviousPracticeDate"] = previousDate;
                        punchCards = db.PunchCards.Where(t => t.PurchaseDate <= practiceDate &&
                        t.PurchaseDate > previousDate).ToList();
                    }
                    if (punchCards.Count > 0) {
                        dt.Rows[i]["PunchCardsSold"] = punchCards.Count;
                        dt.Rows[i]["PunchCardRevenue"] = punchCards.Sum(t => t.PurchaseAmount);
                    }
                    var lineTotal = (decimal)dt.Rows[i]["AdmissionRevenue"] -
                        (decimal)dt.Rows[i]["RentalCost"] -
                        (decimal)dt.Rows[i]["MiscExpense"] +
                        (decimal)dt.Rows[i]["MiscRevenue"] +
                        (decimal)dt.Rows[i]["PunchCardRevenue"];
                    dt.Rows[i]["TotalExpenseRevenue"] = lineTotal;
                    runningTotal += lineTotal;
                    dt.Rows[i]["RunningTotal"] = runningTotal;
                }
            }
            return dt;
        }
    }
}