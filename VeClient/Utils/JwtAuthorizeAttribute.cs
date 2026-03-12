using JWT.Algorithms;
using JWT.Builder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;

namespace VeClient.Utils
{
    public class JwtAuthorizeAttribute : AuthorizeAttribute
    {
        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            try
            {
                var authHeader = actionContext.Request.Headers.Authorization;
                if (authHeader == null || authHeader.Scheme != "Bearer") return false;

                var token = authHeader.Parameter;
                var secret = "DA2s1a44S1S41d218s1f218sd1slmMS";

                var json = JwtBuilder.Create()
                                     .WithAlgorithm(new HMACSHA256Algorithm())
                                     .WithSecret(secret)
                                     .MustVerifySignature()
                                     .Decode(token);

                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}