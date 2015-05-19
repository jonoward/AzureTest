namespace AzureTest.Web.Controllers
{
    using AzureTest.Web.Models.Home;
    using System.Web.Mvc;

    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            var model = new IndexModel { CurrentDateTime = new AzureTest.Service.TimeService().GetCurrentDateTime() };
            return View(model);
        }
    }
}