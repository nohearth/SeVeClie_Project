using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using VeClient.Models;
using VeClient.Models.DTO;
using VeClient.Utils;

namespace VeClient.Controllers
{
    [RoutePrefix("api/seveclie")]
    [JwtAuthorize]
    public class SeVeClieController : ApiController
    {
        private VeClientEntities db = new VeClientEntities();

        [HttpGet()]
        [Route("{id}")]
        public IHttpActionResult GetClieById([FromUri] Guid id)
        {
            try
            {
                if (id == null) return BadRequest("Identificador inválido");

                var clie = db.sp_GetSeVeClieById(id.ToString()).FirstOrDefault();

                return Ok(new
                {
                    Success = true,
                    Data = clie
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPost()]
        [Route("paginated")]
        public IHttpActionResult GetAllClie([FromBody] SeVeClieGetAllDTO request)
        {
            try
            {
                if (request == null) return BadRequest("Datos inválidos");

                var data = db.sp_GetAllSeVeClie(
                    request.page_size,
                    request.page_num,
                    request.order_field,
                    request.order_dir,
                    request.filter_value).ToList();

                return Ok(new
                {
                    Success = true,
                    TotalRecords = data.Count > 0 ?data.First().total_rec : 0,
                    Data = data
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPost]
        public IHttpActionResult AddClie([FromBody] SeVeClieUpdateDTO request)
        {
            try
            {
                if (request == null) return BadRequest("Datos inválidos");

                var clie = new Models.SeVeClie
                {
                    id_clie = Guid.NewGuid().ToString(),
                    cedula = request.cedula,
                    nombre = request.nombre,
                    apellido = request.apellido,
                    genero = request.genero,
                    fecha_nac = request.fecha_nac,
                    id_estado_civil = request.id_estado_civil,
                    created_at = DateTime.Now,
                    updated_at = DateTime.Now
                };

                db.SeVeClies.Add(clie);
                db.SaveChanges();

                return Ok(new
                {
                    Success = true,
                    Message = "Cliente Creado correctamente"
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPut()]
        public IHttpActionResult UpdateClie([FromBody] SeVeClieUpdateDTO request)
        {
            try
            {
                if (request == null) return BadRequest("Datos inválidos");

                var clie = db.SeVeClies.Where(c => c.deleted_at == null).FirstOrDefault(c => c.id_clie == request.id_clie.ToString());

                if (clie == null) return NotFound();

                var resp = db.sp_UpdateSeVeClieById(
                    request.id_clie.ToString(),
                    request.cedula,
                    request.nombre,
                    request.apellido,
                    request.genero,
                    request.fecha_nac,
                    request.id_estado_civil,
                    DateTime.Now);

                return Ok(new
                {
                    Success = true,
                    Message = "Cliente Actualizado correctamente"
                });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpDelete()]
        [Route("{id}")]
        public IHttpActionResult DeleteClie([FromUri] Guid id)
        {
            try
            {
                if (id == null) return BadRequest("Identificador inválido");

                var clie = db.SeVeClies.Where(c => c.deleted_at == null).FirstOrDefault(c => c.id_clie == id.ToString());

                if (clie != null)
                {
                    clie.updated_at = DateTime.Now;
                    clie.deleted_at = DateTime.Now;

                    db.Entry(clie).State = System.Data.Entity.EntityState.Modified;
                    db.SaveChanges();

                    return Ok(new
                    {
                        Success = true,
                        Message = "Cliente Eliminado correctamente"
                    });
                }

                return NotFound();
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }
    }
}
