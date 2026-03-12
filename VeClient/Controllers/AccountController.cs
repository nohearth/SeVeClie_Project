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
    [RoutePrefix("api/account")]
    public class AccountController : ApiController
    {
        private VeClientEntities db = new VeClientEntities();

        [HttpPost]
        [Route("login")]
        public IHttpActionResult Login([FromBody] RequestDTO request)
        {
            try
            {
                if (request == null) return BadRequest("Datos inválidos");

                var user = db.Users.FirstOrDefault(u => u.username == request.username);

                if (user != null)
                {
                    bool validPass = BCrypt.Net.BCrypt.Verify(request.password, user.password);

                    if (validPass)
                    {
                        string token = TokenGen.GenerarToken(request.username, "All");
                        return Ok(new
                        {
                            Success = true,
                            Name = request.username,
                            Token = token
                        });
                    }
                }

                return Unauthorized();
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }
        }

        [HttpPost]
        [Route("register")]
        public IHttpActionResult Register([FromBody] RequestDTO request)
        {
            try
            {
                if (request == null) return BadRequest("Datos inválidos");

                var user = db.Users.FirstOrDefault(u => u.username == request.username);

                if (user != null) return BadRequest("El usuario ya existe");

                string hashPass = BCrypt.Net.BCrypt.HashPassword(request.password);

                var newUser = new Models.User
                {
                    id_user = new Guid().ToString(),
                    username = request.username,
                    password = hashPass,
                    created_at = DateTime.Now,
                    updated_at = DateTime.Now
                };

                try
                {
                    db.Users.Add(newUser);
                    db.SaveChanges();
                }
                catch (Exception ex)
                {
                    throw new InvalidOperationException(ex.Message);
                }

                return Ok(new { Success = true, Message = "Usuario creado con éxito" });
            }
            catch (Exception ex)
            {
                return InternalServerError(ex);
            }            
        }
    }
}
