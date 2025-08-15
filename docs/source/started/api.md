# API

You can launch an API server locally, which accepts web requests for Image/Text to 3D and texturing existing meshes.

```bash
python api_server.py --host 0.0.0.0 --port 8080
```

Set an `API_KEY` environment variable and include it in the `X-API-KEY` header for every request.

A demo post request for image to 3D without texture:

```bash
img_b64_str=$(base64 -i assets/demo.png)
curl -X POST "http://localhost:8080/generate" \
     -H "Content-Type: application/json" \
     -H "X-API-KEY: $API_KEY" \
     -d '{
           "image": "'"$img_b64_str"'"
         }' \
     -o test2.glb
```

Texturing an existing mesh can be done via `/texture`:

```bash
mesh_b64=$(base64 -i test2.glb)
curl -X POST "http://localhost:8080/texture" \
     -H "Content-Type: application/json" \
     -H "X-API-KEY: $API_KEY" \
     -d '{
           "mesh": "'"$mesh_b64"'",
           "image": "'"$img_b64_str"'"
         }' \
     -o textured.glb
```

## Docker

A Dockerfile is provided for GPU-enabled deployments:

```bash
docker build -t hunyuan3d-api .
docker run --gpus all -e API_KEY=$API_KEY -p 8080:8080 hunyuan3d-api
```

The server will listen on port 8080 inside the container.

## Google Cloud

For Google Cloud deployments, create a Compute Engine VM with an NVIDIA L4 GPU and Ubuntu 22.04.
Install the NVIDIA drivers, clone this repository, and then build and run the Docker image as above.
Allow incoming TCP connections on port 8080 through the firewall.
=======
