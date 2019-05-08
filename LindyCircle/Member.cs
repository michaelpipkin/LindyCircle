namespace LindyCircle
{
    using System.Collections.Generic;
    using System.Linq;

    public partial class Member
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Member() {
            Attendances = new HashSet<Attendance>();
            PunchCards = new HashSet<PunchCard>();
        }

        public int MemberID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool Inactive { get; set; }
        public string FirstLastName { get { return FirstName + " " + LastName; } }
        public string LastFirstName { get { return LastName + ", " + FirstName; } }
        public int RemainingPunches
        {
            get { return PunchCards.Count * 5 - Attendances.Where(t => t.PaymentType == 2).Count(); }
        }
        public decimal TotalPaid
        {
            get { return Attendances.Sum(t => t.PaymentAmount) + PunchCards.Sum(t => t.PurchaseAmount); }
        }
        public int TotalAttendance
        {
            get { return Attendances.Count; }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Attendance> Attendances { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<PunchCard> PunchCards { get; set; }
    }
}
