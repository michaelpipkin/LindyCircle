using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;

namespace LindyCircle
{
    [DataObject(true)]
    public class PracticeDB
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetPractices(DateTime? startDate, DateTime? endDate) {
            var dt = new DataTable();
            dt.Columns.Add("PracticeID", typeof(int));
            dt.Columns.Add("PracticeNumber", typeof(int));
            dt.Columns.Add("PracticeDate", typeof(DateTime));
            dt.Columns.Add("PracticeCost", typeof(decimal));
            dt.Columns.Add("Revenue", typeof(decimal));
            dt.Columns.Add("MiscExpense", typeof(decimal));
            dt.Columns.Add("MiscRevenue", typeof(decimal));
            dt.Columns.Add("Attendees", typeof(int));
            using (var db = new LindyCircleContext()) {
                if (startDate == null)
                    startDate = db.Practices.Min(t => t.PracticeDate);
                if (endDate == null)
                    endDate = db.Practices.Max(t => t.PracticeDate);
                var query = from t in db.Practices
                            where t.PracticeDate >= startDate && t.PracticeDate <= endDate
                            orderby t.PracticeDate descending
                            select t;
                foreach (var row in query)
                    dt.Rows.Add(row.PracticeID, row.PracticeNumber, row.PracticeDate, row.PracticeCost,
                        row.Attendances.Sum(t => t.PaymentAmount), row.MiscExpense, row.MiscRevenue, row.Attendances.Count);
            }
            return dt;
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Practice> GetPracticeList() {
            using (var db = new LindyCircleContext())
                return db.Practices.ToList();
        }

        [DataObjectMethod(DataObjectMethodType.Delete)]
        public static void DeletePractice(int practiceID) {
            using (var db = new LindyCircleContext()) {
                var practice = db.Practices.FirstOrDefault(t => t.PracticeID == practiceID);
                if (practice != null) {
                    db.Practices.Remove(practice);
                    db.SaveChanges();
                }
            }
        }
    }
}