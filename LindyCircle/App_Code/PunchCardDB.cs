using System;
using System.ComponentModel;
using System.Data;
using System.Linq;

namespace LindyCircle
{
    [DataObject(true)]
    public class PunchCardDB
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetPunchCardPurchasesByMemberID(int memberID) {
            var dt = new DataTable();
            dt.Columns.Add("PunchCardID", typeof(int));
            dt.Columns.Add("PurchaseDate", typeof(DateTime));
            dt.Columns.Add("PurchaseAmount", typeof(decimal));
            using (var db = new LindyCircleContext()) {
                var query = from t in db.PunchCards
                            where t.MemberID == memberID
                            orderby t.PurchaseDate
                            select t;
                foreach (var row in query)
                    dt.Rows.Add(row.PunchCardID, row.PurchaseDate, row.PurchaseAmount);
            }
            return dt;
        }

        [DataObjectMethod(DataObjectMethodType.Delete)]
        public static void DeletePunchCard(int punchCardID) {
            using (var db = new LindyCircleContext()) {
                var punchCard = db.PunchCards.SingleOrDefault(t => t.PunchCardID == punchCardID);
                if (punchCard != null) {
                    db.PunchCards.Remove(punchCard);
                    db.SaveChanges();
                }
            }
        }
    }
}