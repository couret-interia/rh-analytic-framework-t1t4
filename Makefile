LATEXMK = latexmk
LATEXMK_FLAGS = -pdf -halt-on-error -interaction=nonstopmode
DOCS_DIR = docs
SRC_DIR  = src
TIKZ_DIR = $(DOCS_DIR)/explication-grand-format/latex

# === Audit λ(Couret) FR/EN ===
AUDITS_DIR := audits

AUDIT_LC_TEX := $(AUDITS_DIR)/audit_lambda_couret

AUDIT_FR_TEX       := $(AUDIT_LC_TEX)_FR.tex
AUDIT_FR_PDF       := $(AUDIT_LC_TEX)_FR.pdf
AUDIT_LIGHT_FR_TEX := $(AUDIT_LC_TEX)_light_FR.tex
AUDIT_LIGHT_FR_PDF := $(AUDIT_LC_TEX)_light_FR.pdf

AUDIT_EN_TEX       := $(AUDIT_LC_TEX)_EN.tex
AUDIT_EN_PDF       := $(AUDIT_LC_TEX)_EN.pdf
AUDIT_LIGHT_EN_TEX := $(AUDIT_LC_TEX)_light_EN.tex
AUDIT_LIGHT_EN_PDF := $(AUDIT_LC_TEX)_light_EN.pdf

AUDIT_MANIFEST := $(AUDITS_DIR)/MANIFEST_SHA256.txt

.PHONY: all build all-pdf all-graph all-audit all-demo all-zip
.PHONY: arxiv arxiv-pdf
.PHONY: graph-png graph-png-dark dep-graph-pdf graph-png-fr graph-png-dark-fr
.PHONY: journal-pdf journal-pdf-banner journal-pdf-fr journal-pdf-fr-banner journal-biblatex
.PHONY: guide-pdf guide-beamer
.PHONY: demo-rh-fr demo-rh-en demo-fr-pdf demo-beamer-fr demo-en-pdf demo-beamer-en
.PHONY: audit-graph-pdf audit-graph-pdf-fr audit-graph-pdf-en audit-graph-png audit-graph-png-dark
.PHONY: audit-lambda-fr audit-lambda-en audit-lambda-light-fr audit-lambda-light-en
.PHONY: clean clean-all zenodo zip-pdf zip-final-bundle
.PHONY: pdf watch help

all: all-graph all-pdf
build: all clean arxiv
all-zip: zip-pdf zip-final-bundle
all-pdf: arxiv-pdf journal-pdf journal-pdf-fr all-audit guide-pdf guide-beamer all-demo
all-demo: demo-rh-fr demo-rh-en demo-fr-pdf demo-beamer-fr demo-en-pdf demo-beamer-en
all-graph: graph-png graph-png-dark graph-png-fr graph-png-dark-fr audit-graph-png audit-graph-png-dark

zenodo: all-zip
	@echo "🎓 Zenodo helper: use 'dist/All-docs-…' & '*_FINAL_bundle.zip' for upload."

zip-final-bundle:
	@bash scripts/build_final_bundle.sh
	@echo "➡️  $(shell pwd)/couret-interia_rh-analytic-framework-t1t4-v1.0.0FINAL_bundle.zip"

zip-pdf: all-pdf
	@mkdir -p dist
	@echo "📦 Collecting PDFs into dist/all_pdfs.zip"
	@tmpdir="$(mktemp -d)"; mkdir -p "$tmpdir"; \
	  find . -type f -name '*.pdf' -size +0c \
	    ! -path './.git/*' \
	    ! -path './dist/*' \
	    ! -path './audits/memo/*' \
	    -print0 | xargs -0 -I{} cp -v "{}" "$tmpdir"/ >/dev/null; \
	  (cd "$tmpdir" && zip -qr ../dist/all_pdfs.zip .); \
	  rm -rf "$tmpdir"; \
	  echo "✅ dist/all_pdfs.zip"

# === Audit λ(Couret) FR/EN ===
audit-lambda-fr:
	@latexmk $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) \
	 -e '$$pdflatex = "pdflatex %O %S"; $$biber = "biber %O %B"' \
	$(AUDIT_FR_TEX)
	@echo "✅ Audit λ(Couret) (FR) -> $(AUDIT_FR_PDF)"

audit-lambda-en:
	@latexmk $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) \
	 -e '$$pdflatex = "pdflatex %O %S"; $$biber = "biber %O %B"' \
	$(AUDIT_EN_TEX)
	@echo "✅ Audit λ(Couret) (EN) -> $(AUDIT_EN_PDF)"

audit-lambda-light-fr: audit-graph-pdf-fr
	@latexmk $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_FR_TEX)
	@echo "✅ Audit λ(Couret) light (FR) -> $(AUDIT_LIGHT_FR_PDF)"

audit-lambda-light-en: audit-graph-pdf-en
	@latexmk $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_EN_TEX)
	@echo "✅ Audit λ(Couret) light (EN) -> $(AUDIT_LIGHT_EN_PDF)"

all-audit: audit-lambda-fr audit-lambda-en audit-lambda-light-fr audit-lambda-light-en
	@(cd $(AUDITS_DIR) && sha256sum $(notdir $(AUDIT_FR_PDF)) $(notdir $(AUDIT_EN_PDF)) > MANIFEST_SHA256.txt)
	@echo "🔐 manifest -> $(AUDIT_MANIFEST)"

audit-graph-pdf: audit-graph-pdf-fr audit-graph-pdf-en

audit-graph-pdf-fr:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_FR.tex
	@echo "✅ Audit λ(Couret) graph pdf FR -> $(AUDIT_LC_TEX)_glc_graph_standalone_FR.pdf"
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_FR.tex
	@echo "✅ Audit λ(Couret) graph pdf FR 🖤 dark -> $(AUDIT_LC_TEX)_glc_graph_dark_FR.pdf"

audit-graph-pdf-en:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_EN.tex
	@echo "✅ Audit λ(Couret) graph pdf EN -> $(AUDIT_LC_TEX)_glc_graph_standalone_EN.pdf"
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_EN.tex
	@echo "✅ Audit λ(Couret) graph pdf EN 🖤 dark -> $(AUDIT_LC_TEX)_glc_graph_dark_EN.pdf"

audit-graph-png: audit-graph-pdf
	@which pdftoppm >/dev/null || (echo "Install poppler-utils (pdftoppm)"; exit 1)
	@pdftoppm -png -singlefile $(AUDIT_LC_TEX)_glc_graph_standalone_FR.pdf $(AUDIT_LC_TEX)_glc_graph_standalone_FR
	@echo "✅ Audit λ(Couret) FR PNG -> $(AUDIT_LC_TEX)_glc_graph_standalone_FR.png"
	@pdftoppm -png -singlefile $(AUDIT_LC_TEX)_glc_graph_standalone_EN.pdf $(AUDIT_LC_TEX)_glc_graph_standalone_EN
	@echo "✅ Audit λ(Couret) EN PNG -> $(AUDIT_LC_TEX)_glc_graph_standalone_EN.png"

audit-graph-png-dark: audit-graph-pdf
	@which pdftoppm >/dev/null || (echo "Install poppler-utils (pdftoppm)"; exit 1)
	@pdftoppm -png -singlefile $(AUDIT_LC_TEX)_glc_graph_dark_FR.pdf $(AUDIT_LC_TEX)_glc_graph_dark_FR
	@echo "🖤 Audit λ(Couret) dark FR PNG -> $(AUDIT_LC_TEX)_glc_graph_dark_FR.png"
	@pdftoppm -png -singlefile $(AUDIT_LC_TEX)_glc_graph_dark_EN.pdf $(AUDIT_LC_TEX)_glc_graph_dark_EN
	@echo "🖤 Audit λ(Couret) dark EN PNG -> $(AUDIT_LC_TEX)_glc_graph_dark_EN.png"
# === Audit λ(Couret) FR/EN ===

dep-graph-pdf:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone.tex
	@echo "✅ graph -> $(TIKZ_DIR)/graphe_dependances_standalone.pdf"
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone_FR.tex
	@echo "✅ graph -> $(TIKZ_DIR)/graphe_dependances_standalone_FR.pdf"

graph-png: dep-graph-pdf
	@which pdftoppm >/dev/null || (echo "Install poppler-utils (pdftoppm)"; exit 1)
	@pdftoppm -png -singlefile $(TIKZ_DIR)/graphe_dependances_standalone.pdf $(TIKZ_DIR)/graphe_dependances_standalone
	@echo "✅ PNG -> $(TIKZ_DIR)/graphe_dependances_standalone.png"

graph-png-dark: dep-graph-pdf
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark.tex
	@pdftoppm -png -singlefile $(TIKZ_DIR)/graphe_dependances_dark.pdf $(TIKZ_DIR)/graphe_dependances_dark
	@echo "🖤 dark PNG -> $(TIKZ_DIR)/graphe_dependances_dark.png"

graph-png-fr: dep-graph-pdf
	@which pdftoppm >/dev/null || (echo "Install poppler-utils (pdftoppm)"; exit 1)
	@pdftoppm -png -singlefile $(TIKZ_DIR)/graphe_dependances_standalone_FR.pdf $(TIKZ_DIR)/graphe_dependances_standalone_FR
	@echo "✅ PNG -> $(TIKZ_DIR)/graphe_dependances_standalone_FR.png"

graph-png-dark-fr: dep-graph-pdf
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark_FR.tex
	@pdftoppm -png -singlefile $(TIKZ_DIR)/graphe_dependances_dark_FR.pdf $(TIKZ_DIR)/graphe_dependances_dark_FR
	@echo "🖤 dark PNG -> $(TIKZ_DIR)/graphe_dependances_dark_FR.png"

arxiv-pdf:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=./ ./main_arxiv.tex
	@echo "✅ arxiv -> ./main_arxiv.pdf"

journal-pdf: dep-graph-pdf
	@sed -i 's/\\interiabantrue/\\interiabanfalse/' proofarticle.cls
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal.tex
	@echo "✅ journal -> src/main_journal.pdf"

journal-pdf-fr: dep-graph-pdf
	@sed -i 's/\\interiabantrue/\\interiabanfalse/' proofarticle.cls
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal_FR.tex
	@echo "✅ journal (FR) -> src/main_journal_FR.pdf"

# InterIA banner version (blue-white)
journal-pdf-banner: dep-graph-pdf
	@sed -i 's/\\interiabanfalse/\\interiabantrue/' proofarticle.cls
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal_FR.tex
	@echo "🎨 journal + bandeau InterIA -> src/main_journal.pdf"

journal-pdf-fr-banner: dep-graph-pdf
	@sed -i 's/\\interiabanfalse/\\interiabantrue/' proofarticle.cls
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal_FR.tex
	@echo "🎨 journal (FR + bandeau InterIA) -> src/main_journal_FR.pdf"

journal-biblatex: dep-graph-pdf
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) \
	 -e '$$pdflatex = "pdflatex %O %S"; $$biber = "biber %O %B"' \
	 $(SRC_DIR)/main_journal.tex
	@echo "✅ journal (biblatex) -> src/main_journal.pdf"
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) \
	 -e '$$pdflatex = "pdflatex %O %S"; $$biber = "biber %O %B"' \
	 $(SRC_DIR)/main_journal_FR.tex
	@echo "✅ journal [FR] (biblatex) -> src/main_journal_FR.pdf"

pdf:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main.tex

guide-pdf: dep-graph-pdf
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire.tex
	@echo "✅ guide -> $(DOCS_DIR)/guide_interdisciplinaire.pdf"

guide-beamer: dep-graph-pdf
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire_beamer.tex
	@echo "✅ guide beamer -> $(DOCS_DIR)/guide_interdisciplinaire_beamer.pdf"

demo-fr-pdf:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_FR.tex
	@echo "✅ demo T1′→T4 (FR) -> $(DOCS_DIR)/demo_T1p_T4_FR.pdf"

demo-en-pdf:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_EN.tex
	@echo "✅ demo T1′→T4 (EN) -> $(DOCS_DIR)/demo_T1p_T4_EN.pdf"

demo-beamer-fr:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_FR.tex
	@echo "✅ demo Beamer (FR) -> $(DOCS_DIR)/demo_T1p_T4_beamer_FR.pdf"

demo-beamer-en:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_EN.tex
	@echo "✅ demo Beamer (EN) -> $(DOCS_DIR)/demo_T1p_T4_beamer_EN.pdf"

demo-rh-fr:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)/demonstration_finale_RH_FR.tex
	@echo "✅ demo Finale T1′→T4 (FR) -> $(DOCS_DIR)/demonstration_finale_RH_FR.pdf"

demo-rh-en:
	@$(LATEXMK) $(LATEXMK_FLAGS) -outdir=$(DOCS_DIR) $(DOCS_DIR)//demonstration_finale_RH_EN.tex
	@echo "✅ demo Finale T1′→T4 (EN) -> $(DOCS_DIR)/demonstration_finale_RH_EN.pdf"

watch:
	@$(LATEXMK) -pvc $(LATEXMK_FLAGS) -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal.tex

clean:
	@$(LATEXMK) -c -outdir=./ ./main_arxiv.tex
	@$(LATEXMK) -c -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal.tex
	@$(LATEXMK) -c -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal_FR.tex
	@$(LATEXMK) -c -outdir=$(SRC_DIR) $(SRC_DIR)/main.tex
	@$(LATEXMK) -c -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone.tex
	@$(LATEXMK) -c -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark.tex
	@$(LATEXMK) -c -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone_FR.tex
	@$(LATEXMK) -c -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark_FR.tex
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_FR_TEX)
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_EN_TEX)
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_FR_TEX)
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_EN_TEX)
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_FR.tex
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_EN.tex
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_FR.tex
	@$(LATEXMK) -c -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_EN.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire_beamer.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_FR.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_EN.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_FR.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_EN.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demonstration_finale_RH_FR.tex
	@$(LATEXMK) -c -outdir=$(DOCS_DIR) $(DOCS_DIR)/demonstration_finale_RH_EN.tex
	@rm -f ./*.bbl
	@rm -f $(SRC_DIR)/*.bbl
	@rm -f $(AUDITS_DIR)/*.bbl
	@rm -f $(AUDITS_DIR)/*.xml
	@rm -f $(DOCS_DIR)/*.bbl
	@rm -f $(DOCS_DIR)/*.nav
	@rm -f $(DOCS_DIR)/*.snm
	@echo "✅ fichiers de compilation nettoyés"

clean-all: clean
	@$(LATEXMK) -C -outdir=./ ./main_arxiv.tex
	@$(LATEXMK) -C -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal.tex
	@$(LATEXMK) -C -outdir=$(SRC_DIR) $(SRC_DIR)/main_journal_FR.tex
	@$(LATEXMK) -C -outdir=$(SRC_DIR) $(SRC_DIR)/main.tex
	@$(LATEXMK) -C -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone.tex
	@$(LATEXMK) -C -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark.tex
	@$(LATEXMK) -C -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_standalone_FR.tex
	@$(LATEXMK) -C -outdir=$(TIKZ_DIR) $(TIKZ_DIR)/graphe_dependances_dark_FR.tex
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_FR_TEX)
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_EN_TEX)
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_FR_TEX)
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LIGHT_EN_TEX)
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_FR.tex
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_standalone_EN.tex
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_FR.tex
	@$(LATEXMK) -C -outdir=$(AUDITS_DIR) $(AUDIT_LC_TEX)_glc_graph_dark_EN.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/guide_interdisciplinaire_beamer.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_FR.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_EN.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_FR.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demo_T1p_T4_beamer_EN.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demonstration_finale_RH_FR.tex
	@$(LATEXMK) -C -outdir=$(DOCS_DIR) $(DOCS_DIR)/demonstration_finale_RH_EN.tex
	@rm -f $(AUDITS_DIR)/*.pdf
	@rm -f $(AUDITS_DIR)/*.png
	@rm -f $(AUDITS_DIR)/*.txt
	@rm -f $(DOCS_DIR)/*.pdf
	@rm -f $(TIKZ_DIR)/*.png
	@rm -f $(TIKZ_DIR)/*.pdf
	@echo "✅ images et fichiers pdf éffacés"

arxiv:
	@mkdir -p dist
	bash scripts/make_arxiv.sh
	@echo "✅ fichier dist/arxiv_package.tar.gz créé"

help:
	@echo "make zenodo | build | all | all-pdf | all-zip | zip-pdf | zip-final-bundle | dep-graph-pdf | all-graph | graph-png | graph-png-dark | graph-png-fr | graph-png-dark-fr | arxiv-pdf | journal-pdf | audit-graph-pdf | audit-graph-pdf-fr | audit-graph-pdf-en | audit-graph-png | audit-graph-png-dark | all-audit | audit-lambda-fr | audit-lambda-en | audit-lambda-light-fr | audit-lambda-light-en | journal-pdf-banner | journal-pdf-fr | journal-pdf-fr-banner | journal-biblatex | guide-pdf | guide-beamer | all-demo | demo-rh-fr | demo-rh-en | demo-fr-pdf | demo-en-pdf | demo-beamer-fr | demo-beamer-en | arxiv | clean | clean-all"
