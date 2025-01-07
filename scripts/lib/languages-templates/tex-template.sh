#!/bin/bash

texBasicTemplate=$(cat << EOF
\documentclass[12pt]{article}

\title{Example Documtent}
\author{Author Name}
\date{\today}

\begin{document}

\maketitle

\section{Title}
text

\subsection{Subtitle}
text

\end{document}
EOF
)
