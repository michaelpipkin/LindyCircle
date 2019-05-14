using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;

namespace LindyCircle
{
    [DataObject(true)]
    public class AttendanceDB
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public static DataTable GetPracticeAttendees(int practiceID) {
            var dt = new DataTable();
            dt.Columns.Add("AttendanceID", typeof(int));
            dt.Columns.Add("MemberID", typeof(int));
            dt.Columns.Add("Member", typeof(string));
            dt.Columns.Add("PaymentType", typeof(int));
            dt.Columns.Add("PaymentTypeText", typeof(string));
            dt.Columns.Add("PaymentAmount", typeof(decimal));
            using (var db = new LindyCircleContext()) {
                var query = from t in db.Attendances
                            where t.PracticeID == practiceID
                            orderby t.Member.FirstName, t.Member.LastName
                            select t;
                foreach (var row in query)
                    dt.Rows.Add(row.AttendanceID, row.MemberID, row.Member.FirstLastName, row.PaymentType, 
                        row.PaymentTypeText, row.PaymentAmount);
            }
            return dt;
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public static List<Member> GetMembersNotInPractice(int practiceID) {
            using (var db = new LindyCircleContext()) {
                var members = db.Members.Where(t => !t.Inactive);
                var attendees = db.Attendances.Where(t => t.PracticeID == practiceID).Select(t => t.Member);
                return members.Except(attendees).OrderBy(t => t.FirstName).ThenBy(t => t.LastName).ToList();
            }
        }
    }
}