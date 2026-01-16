# Docker & Google Cloud Run Deployment Guide

This website is now containerized and ready for Google Cloud Run deployment.

## Prerequisites

- Docker installed locally
- Google Cloud SDK (`gcloud` CLI) installed
- A Google Cloud Platform project with billing enabled
- Cloud Run API enabled in your GCP project

## Local Development with Docker

### Build the Docker image:
```bash
docker build -t hadi-korjieh-website .
```

### Run locally:
```bash
docker run -p 8080:8080 hadi-korjieh-website
```

Visit `http://localhost:8080` to view the website.

### Test the container:
```bash
# Health check endpoint
curl http://localhost:8080/health
```

## Deploy to Google Cloud Run

### Option 1: Using gcloud CLI (Recommended)

1. **Set your GCP project:**
```bash
gcloud config set project YOUR_PROJECT_ID
```

2. **Build and submit to Container Registry:**
```bash
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/hadi-korjieh
```

3. **Deploy to Cloud Run:**
```bash
gcloud run deploy hadi-korjieh \
  --image gcr.io/YOUR_PROJECT_ID/hadi-korjieh \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

### Option 2: Using Cloud Build (CI/CD)

The `cloudbuild.yaml` file is configured for automated deployments.

1. **Trigger a build:**
```bash
gcloud builds submit --config cloudbuild.yaml
```

2. **Set up automated builds from Git:**
```bash
gcloud builds triggers create github \
  --repo-name=YOUR_REPO \
  --repo-owner=YOUR_GITHUB_USERNAME \
  --branch-pattern="^main$" \
  --build-config=cloudbuild.yaml
```

### Option 3: Deploy directly from source

```bash
gcloud run deploy hadi-korjieh \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

## Configuration

- **Port:** The application runs on port 8080 (Cloud Run requirement)
- **Web Server:** Nginx Alpine (lightweight and efficient)
- **Health Check:** Available at `/health` endpoint
- **Compression:** Gzip enabled for better performance
- **Caching:** Static assets cached for 1 year

## Environment Variables (if needed)

If you need to add environment variables in Cloud Run:

```bash
gcloud run deploy hadi-korjieh \
  --set-env-vars KEY1=VALUE1,KEY2=VALUE2
```

## Custom Domain Setup

1. **Map a custom domain:**
```bash
gcloud run domain-mappings create \
  --service hadi-korjieh \
  --domain your-domain.com \
  --region us-central1
```

2. Follow the DNS configuration instructions provided by the command output.

## Monitoring & Logs

View logs:
```bash
gcloud run services logs read hadi-korjieh --region us-central1
```

View service details:
```bash
gcloud run services describe hadi-korjieh --region us-central1
```

## Cost Optimization

Cloud Run charges only when requests are being handled. For a static website with moderate traffic, costs are typically minimal:
- First 2 million requests per month are free
- 360,000 GB-seconds of memory per month are free
- 180,000 vCPU-seconds per month are free

## Security Features

- HTTPS enabled by default
- Security headers configured (X-Frame-Options, X-Content-Type-Options, X-XSS-Protection)
- Minimal attack surface using Alpine Linux
- No unnecessary packages or services

## Troubleshooting

**Container fails to start:**
- Check logs: `docker logs <container_id>`
- Ensure port 8080 is exposed and nginx is configured correctly

**Cloud Run deployment fails:**
- Verify billing is enabled on your GCP project
- Ensure Cloud Run API is enabled
- Check container logs in Cloud Console

**Website not loading:**
- Check if service is public: `--allow-unauthenticated` flag
- Verify all static files are copied in Dockerfile
- Test locally with Docker first

## Additional Resources

- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Container Registry Documentation](https://cloud.google.com/container-registry/docs)
- [Nginx Documentation](https://nginx.org/en/docs/)
