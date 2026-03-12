using JWT.Algorithms;
using JWT.Builder;
using System;


namespace VeClient.Utils
{
    public class TokenGen
    {
        private const string SecretKey = "DA2s1a44S1S41d218s1f218sd1slmMS";

        public static string GenerarToken(string username, string role)
        {
            var epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            var expiry = DateTime.UtcNow.AddHours(24);
            var secondsSinceEpoch = (long)(expiry - epoch).TotalSeconds;

            var token = JwtBuilder.Create()
                          .WithAlgorithm(new HMACSHA256Algorithm())
                          .WithSecret(SecretKey)
                          .AddClaim("exp", secondsSinceEpoch)
                          .AddClaim("username", username)
                          .AddClaim("role", role)
                          .Encode();

            return token;
        }
    }
}