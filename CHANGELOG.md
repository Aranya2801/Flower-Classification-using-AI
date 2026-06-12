# Changelog

All notable changes to FlowerAI are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versioning follows [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added
- Nothing yet

---

## [1.0.0] — 2024-06-01

### Added
- **Multi-Model Ensemble**: EfficientNet-B7, ViT-L/16, ConvNeXt-XL, Swin-L, CLIP ViT-L/14, DINOv2 ViT-L/14
- **MBIN Architecture**: Novel multi-modal architecture combining visual, environmental, knowledge graph, and user data
- **Flower Classification**: 102+ species on Oxford 102 Flowers benchmark (99.1% top-1)
- **Disease Detection**: 65-class detection on PlantVillage + PlantDoc (94.7% mAP)
- **Botanical RAG Chatbot**: LangChain + ChromaDB/FAISS + GPT-4o/Gemini Pro
- **Growth Forecasting**: LSTM + Temporal Fusion Transformer (RMSE 0.043)
- **Smart Garden Assistant**: Watering/fertiliser schedules, companion planting, seasonal tips
- **Recommendation Engine**: DINOv2 embeddings + FAISS vector similarity search
- **Video Analytics**: YOLOv9 + DeepSORT tracking + temporal classification
- **XAI Dashboard**: Grad-CAM++, SHAP, Attention Rollout visualisations
- **FastAPI Backend**: 24 production endpoints with JWT auth, RBAC, rate limiting
- **Next.js Frontend**: Modern dark-theme UI with drag-and-drop upload
- **Flutter Mobile App**: Cross-platform iOS/Android with real-time camera inference
- **MLOps Stack**: MLflow + W&B + DVC + Airflow + Prefect
- **Monitoring**: Prometheus + Grafana + Evidently drift detection
- **Cloud Deployment**: Docker + Kubernetes + Terraform (AWS EKS + GCP GKE)
- **Security**: JWT, OAuth2, RBAC, rate limiting, input validation, Vault integration
- **CI/CD**: GitHub Actions with multi-stage pipeline, Trivy scanning, auto-deploy

### Research
- Published MBIN architecture paper draft (`research/MBIN_paper.md`)
- Novel Hierarchical Cross-Modal Attention (HCMA) mechanism
- Botanical Knowledge Graph Encoder (BKGE) using GAT v2
- Gated Multi-Modal Fusion (GMMF) with calibrated uncertainty

---

[Unreleased]: https://github.com/your-username/flower-ai/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/your-username/flower-ai/releases/tag/v1.0.0
