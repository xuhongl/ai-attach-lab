using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using app.Models;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Net.Http;

namespace app.Controllers
{
    public class HomeController : Controller
    {
        private IConfiguration _config;

        public HomeController(IConfiguration config)
        {
            _config = config;
        }

        public async Task<IActionResult> Index()
        {
            var apiBaseUrl = _config.GetValue<string>("API_BASE_URL");
            var valuesUrl = System.IO.Path.Combine(apiBaseUrl, "api/values");
            var client = new HttpClient();
            var result = await client.GetAsync(valuesUrl);
            dynamic values = JsonConvert.DeserializeObject(await result.Content.ReadAsStringAsync());
            ViewData["DBVersion"] = values[0];
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
