namespace LindyCircle
{
    using System;
    using System.Collections.Generic;
    
    public partial class Practice
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public Practice()
        {
            this.Attendances = new HashSet<Attendance>();
        }
    
        public int PracticeID { get; set; }
        public DateTime PracticeDate { get; set; }
        public int PracticeNumber { get; set; }
        public decimal PracticeCost { get; set; }
        public decimal MiscExpense { get; set; }
        public decimal MiscRevenue { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Attendance> Attendances { get; set; }
    }
}
