\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{proofarticle}[2026/02/27 v1.0 journal-ready proof class]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[11pt,a4paper]{article}
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\RequirePackage{microtype}
\RequirePackage{csquotes}
\RequirePackage{amsmath,amsthm,amssymb,mathtools,amsfonts}
\RequirePackage{thmtools}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage[nameinlink,noabbrev,capitalize]{cleveref}
\RequirePackage[a4paper,margin=2.5cm]{geometry}
\RequirePackage{enumitem}\setlist{nosep}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{bookmark}
% Nettoyage des maths dans les signets PDF (hyperref)
\pdfstringdefDisableCommands{%
  \def\to{→}% remplace \to par U+2192 dans les signets
  \def\PW{PW}% pas de math en bookmark
  \def\XiA{\Xi A}% fallback texte
  \def\Cfrw{Cfr(w)}
  \def\Thetaw{\Theta_w}
}
\declaretheorem[numberwithin=section]{theorem}
\declaretheorem[sibling=theorem]{lemma,proposition,corollary}
\declaretheorem[style=definition,sibling=theorem]{definition,example}
\declaretheorem[style=remark,sibling=theorem]{remark}
\newcommand{\eps}{\varepsilon}
\newcommand{\constdep}[1]{\textup{(dep: #1)}}
% ===== Macros PW/Xi/weights/Gram/constants =====
\newcommand{\PW}{\mathcal{PW}}
\newcommand{\XiA}{\Xi_A}
\newcommand{\wpk}{w_{p,k}}
\newcommand{\Gpw}{G^{(w)}}
\newcommand{\Cfrw}{C_{\mathrm{fr}}^{(w)}}
\newcommand{\Thetaw}{\Theta_w}
% opérateurs utiles
\DeclareMathOperator{\supp}{supp}
\DeclareMathOperator{\Res}{Res}
\DeclareMathOperator{\diag}{diag}
\DeclareMathOperator{\Tr}{Tr}
\renewcommand{\qedsymbol}{$\blacksquare$}

% ==========================================
% === InterIA Banner (switchable, FR) ===
% ==========================================
\RequirePackage{tikz}
\newif\ifinteriaban
\interiabanfalse       % Default: no banner (neutral academic)

\newcommand{\interiaBanner}{
  \begin{tikzpicture}[remember picture, overlay]
    \fill[left color=blue!45!black, right color=white, opacity=0.92]
      (current page.north west) rectangle ([yshift=-2.1cm]current page.north east);
    \node[anchor=north west, xshift=1.2cm, yshift=-1cm, text=white,
          font=\sffamily\bfseries\Large]
      {InterIA — Cadre Analytique Modulaire T1$′$–T4};
    \node[anchor=north east, xshift=-1.2cm, yshift=-1.1cm, text=white,
          font=\sffamily\small]
      {Riemann Hypothesis Framework · Version FR};
  \end{tikzpicture}
}

\AddToHook{shipout/firstpage}{
  \ifinteriaban
    \interiaBanner
  \fi
}

% ------------------------------------------
% end InterIA Banner
% ------------------------------------------

\endinput
