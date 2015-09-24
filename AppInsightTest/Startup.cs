using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(AppInsightTest.Startup))]
namespace AppInsightTest
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
