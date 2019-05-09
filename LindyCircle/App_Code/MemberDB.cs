using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;

namespace LindyCircle
{
    [DataObject(true)]
    public class MemberDB
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetMembers(bool active) {
            var dt = new DataTable();
            dt.Columns.Add("MemberID", typeof(int));
            dt.Columns.Add("MemberName", typeof(string));
            dt.Columns.Add("Attended", typeof(int));
            dt.Columns.Add("PunchCards", typeof(int));
            dt.Columns.Add("UnusedPunches", typeof(int));
            dt.Columns.Add("Inactive", typeof(bool));
            using (var db = new LindyCircleContext()) {
                var query = from t in db.Members
                            where t.Inactive == false || t.Inactive != active
                            orderby t.FirstName, t.LastName
                            select t;
                foreach (var row in query)
                    dt.Rows.Add(row.MemberID, row.FirstLastName, row.Attendances.Count, 
                        row.PunchCards.Count, row.RemainingPunches, row.Inactive);
            }
            return dt;
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Member> GetMemberList() {
            using (var db = new LindyCircleContext())
                return db.Members.OrderBy(t => t.FirstName).ThenBy(t => t.LastName).ToList();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Member> GetActiveMemberList() {
            using (var db = new LindyCircleContext())
                return db.Members.Where(t => !t.Inactive).OrderBy(t => t.FirstName).ThenBy(t => t.LastName).ToList();
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetMemberHistory(int memberID) {
            var dt = new DataTable();
            dt.Columns.Add("PracticeDate", typeof(DateTime));
            dt.Columns.Add("PaymentType", typeof(string));
            dt.Columns.Add("PaymentAmount", typeof(decimal));
            using (var db = new LindyCircleContext()) {
                var query = from t in db.Attendances
                            where t.MemberID == memberID
                            orderby t.Practice.PracticeDate
                            select t;
                foreach (var row in query)
                    dt.Rows.Add(row.Practice.PracticeDate, row.PaymentTypeText, row.PaymentAmount);
            }
            return dt;
        }
    }
}