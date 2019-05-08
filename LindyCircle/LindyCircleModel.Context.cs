namespace LindyCircle
{
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    
    public partial class LindyCircleContext : DbContext
    {
        public LindyCircleContext()
            : base("name=LindyCircleContext")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<Attendance> Attendances { get; set; }
        public virtual DbSet<Default> Defaults { get; set; }
        public virtual DbSet<Member> Members { get; set; }
        public virtual DbSet<Practice> Practices { get; set; }
        public virtual DbSet<PunchCard> PunchCards { get; set; }
    }
}
