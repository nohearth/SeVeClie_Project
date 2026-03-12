using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using VeClient.Models;
using VeClient.Utils;

namespace VeClient.Controllers
{
    [RoutePrefix("api/catalog")]
    public class CatalogController : ApiController
    {
        private VeClientEntities db = new VeClientEntities();

        [HttpGet]
        [JwtAuthorize]
        [Route("civil-status")]
        public IHttpActionResult Get()
        {
            try
            {
                var data = db.EstCivils.Select(ec => new
                {
                    Id = ec.id_estado_civil,
                    Value = ec.estado_civil
                }).ToList();

                return Ok(new
                {
                    Success = true,
                    Data = data
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
    }
}
