# 🚀 Actividades. Servicios de Transferencia de Archivos.

### Actividad 1.
#### 🏁 Escenario

La empresa "Web-Dev S.A." necesita un servidor central donde sus desarrolladores puedan gestionar sus propios espacios web. Como administrador, debes configurar un entorno de **hosting compartido** que cumpla con:

1. **Seguridad Multi-Protocolo:** Soporte para FTPS y SFTP.
2. **Aislamiento:** Cada desarrollador enjaulado en su *home*.
3. **Publicación Automática:** Uso de directorios de usuario (`userdir`).
4. **Portabilidad:** Orquestación mediante contenedores.

#### 📝 Tareas a realizar y Pruebas de Funcionamiento

#### Fase 1: Configuración de Usuarios y Hosting (Linux)

* **Tarea:** Instalar servicios, crear usuarios `dev_web1`/`dev_web2` y carpeta `public_html`. Activar `mod_userdir` en el servidor web.
* **✅ Prueba de funcionamiento:** Crea un archivo `test.html` a mano en `/home/dev_web1/public_html`. Abre el navegador y accede a `http://localhost/~dev_web1/test.html`.
* *Resultado esperado:* Debe visualizarse el contenido del archivo. Si recibes un error 403, revisa los permisos de ejecución (`chmod +x`) de la carpeta `/home/dev_web1`.


#### Fase 2: Blindaje y Dualidad (FTPS vs SFTP)

* **Tarea A (FTPS):** Configurar `vsftpd` con TLS forzado y `chroot`.
* **✅ Prueba de funcionamiento (FTPS):** Intenta conectar con un cliente FTP (FileZilla) seleccionando "FTP Plano" (sin cifrado).
* *Resultado esperado:* El servidor debe rechazar la conexión con un mensaje tipo "530 Non-anonymous sessions must use encryption".


* **Tarea B (SFTP):** Configurar SSH para que el grupo `devs` solo tenga acceso SFTP enjaulado.
* **✅ Prueba de funcionamiento (SFTP):** Desde la terminal, intenta hacer login por SSH normal: `ssh dev_web1@localhost`.
* *Resultado esperado:* La conexión debe cerrarse inmediatamente tras el login o mostrar un mensaje de "This service allows sftp connections only".



#### Fase 3: Despliegue en Contenedores (Docker)

* **Tarea:** Crear un `docker-compose.yml` para un servicio de transferencia.
* **✅ Prueba de funcionamiento:** Levanta el entorno con `docker-compose up -d`. Crea un archivo en la carpeta mapeada de tu máquina anfitrión.
* *Resultado esperado:* Al conectar al contenedor mediante FTP/SFTP, el archivo creado en el anfitrión debe aparecer listado en el cliente.



#### Fase 4: Integración Final y Flujo de Trabajo

* **Tarea:** Subir un `index.html` real mediante el cliente configurado (FileZilla/VS Code) usando SFTP o FTPS.
* **✅ Prueba de funcionamiento:** Accede a la URL final `http://IP-SERVIDOR/~dev_web2/`.
* *Resultado esperado:* Visualización de la web subida. Verifica en el log del cliente que el puerto usado ha sido el 21 (FTPS) o el 22 (SFTP) según tu elección.


#### 📂 Entrega (Documentación en Markdown)

Deberás publicar un documento que incluya:

1. **Tabla Comparativa:** Puertos y capas de seguridad de FTPS vs SFTP.
2. **Evidencias de Configuración:** Capturas de `vsftpd.conf` y `sshd_config` (solo las líneas modificadas).
3. **Evidencias de Funcionamiento:**
      * Captura del navegador con la web de un usuario funcionando.
      * Captura del mensaje de error al intentar conectar por FTP sin TLS (demostrando que el cifrado es obligatorio).
      * Captura de la terminal demostrando que el usuario no puede navegar fuera de su *home* (`pwd` debe mostrar `/`).


4. **Código Docker:** El contenido de tu archivo `docker-compose.yml`.

