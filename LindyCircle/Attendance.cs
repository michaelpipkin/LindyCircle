namespace LindyCircle
{

    public partial class Attendance
    {
        public int AttendanceID { get; set; }
        public int MemberID { get; set; }
        public int PracticeID { get; set; }
        public int PaymentType { get; set; }
        public string PaymentTypeText
        {
            get
            {
                switch (PaymentType) {
                    case 0: return "None";
                    case 1: return "Cash";
                    case 2: return "Punch card";
                    default: return "Other";
                }
            }
        }
        public decimal PaymentAmount { get; set; }
    
        public virtual Member Member { get; set; }
        public virtual Practice Practice { get; set; }
    }
}
