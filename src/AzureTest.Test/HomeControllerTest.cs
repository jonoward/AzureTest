namespace AzureTest.Test
{
    using System.Web.Mvc;
    using AzureTest.Web.Controllers;
    using NUnit.Framework;

    [TestFixture]
    public class HomeControllerTest
    {
        [Test]
        public void Should_return_view_for_index_action()
        {
            var controller = new HomeController();
            var result = controller.Index();
            Assert.IsInstanceOf<RedirectResult>(result);
        }
    }
}
