namespace LindyCircle
{
    using System;
    using System.Collections.Generic;
    
    public partial class PunchCard
    {
        public int PunchCardID { get; set; }
        public int MemberID { get; set; }
        public System.DateTime PurchaseDate { get; set; }
        public decimal PurchaseAmount { get; set; }
    
        public virtual Member Member { get; set; }
    }
}
