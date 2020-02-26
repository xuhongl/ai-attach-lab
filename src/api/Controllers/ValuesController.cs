using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Data.SqlClient;

namespace api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {

        private IConfiguration _config;

        public ValuesController(IConfiguration config)
        {
            _config = config;
        }

        // GET api/values
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            var connectionString = _config.GetValue<string>("DB_CONNECTION_STRING");
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                var version = new SqlCommand("SELECT @@VERSION", connection).ExecuteScalar();
                var objectCount = new SqlCommand($"SELECT count(*) from sys.all_objects", connection).ExecuteScalar();
                return new string[] { $"SQL Server version: {version}", $"Database object count: {objectCount}" };
            }
        }
    }
}
