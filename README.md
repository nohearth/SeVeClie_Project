# SeVeClie_Project
---

## 🛠️ Tecnologías Utilizadas

* **Backend:** C# / .NET Framework 4.5.2
* **Frontend:** HTML5, jQuery, Bootstrap 4
* **Base de Datos:** SQL Server 2018 (Express/Standard)
* **Reportes:** Microsoft Report Viewer (v10.0.0.0)
* **Componentes:** DataTables.net para el listado dinámico.

---

## 📋 Requisitos de Instalación

### 1. Requisitos del Sistema
* Visual Studio 2015 o superior.
* SQL Server Management Studio (SSMS).
* Microsoft Report Viewer Runtime (compatible con v10).

### 2. Configuración de Base de Datos
1. Ejecuta el script en la carpeta `/SQL`:
   - `SeVeClie.sql` (Estructura de base de datos, tablas y procedimientos almacenados).

### 3. Configuración del Proyecto (`Web.config`)
Se debe cambiar/agregar la cadena de conexión correspondiente debido al uso mixto de Entity Framework y APO.NET para reportes:

## Ejemplos:
<connectionStrings>
  <add name="VeClientEntities" connectionString="metadata=res://...;provider connection string='...'" />
  
  <add name="VeClientDb" connectionString="Data Source=.;Initial Catalog=VeClientDB;User ID=sa;Password=TU_CLAVE;" />
</connectionStrings>