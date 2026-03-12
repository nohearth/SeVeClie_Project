using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace VeClient.Models.DTO
{
    public class SeVeClieGetAllDTO
    {
        public int page_size { get; set; } = 10;
        public int page_num { get; set; } = 0;
        public string order_field { get; set; } = "cedula";
        public string order_dir { get; set; } = "asc";
        public string filter_value { get; set; }
    }

    public class SeVeClieUpdateDTO
    {
        public Guid id_clie { get; set; }
        public string cedula { get; set; }
        public string nombre { get; set; }
        public string apellido { get; set; }
        public string genero { get; set; }
        public DateTime fecha_nac { get; set; }
        public int id_estado_civil { get; set; }
        public DateTime updated_at { get; set; }
    }
}