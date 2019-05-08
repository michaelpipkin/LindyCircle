using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(LindyCircle.Startup))]
namespace LindyCircle
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            //ConfigureAuth(app);
        }
    }
}
