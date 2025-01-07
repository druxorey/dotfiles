#!/bin/bash

basicTemplate=$(cat << EOF
\documentclass[12pt]{article}

\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage{geometry}
\usepackage{listings}
\usepackage{xcolor}
\usepackage{fancyhdr}

\definecolor{KEYWORDS}{HTML}{0000ff}
\definecolor{COMMENTS}{HTML}{888888}
\definecolor{STRINGS}{HTML}{ff0000}

\lstset{
	frame=shadowbox,
	language=c++,
	aboveskip=3mm,
	belowskip=3mm,
	xleftmargin=10mm,
	xrightmargin=10mm,
	showstringspaces=false,
	columns=flexible,
	basicstyle={\small\ttfamily},
	numbers=left,
	numberstyle=\tiny\color{COMMENTS},
	keywordstyle=\color{KEYWORDS},
	commentstyle=\color{COMMENTS},
	stringstyle=\color{STRINGS},
	breaklines=true,
	breakatwhitespace=true,
	tabsize=4
}

\geometry{
  a4paper,
  left=25mm,
  right=25mm,
  top=25mm,
  bottom=25mm
}

\title{DOCUMENT_TITLE}
\author{AUTHOR}
\date{\today}

\begin{document}

\section{Background}
\subsection{Historical Context}
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada. 

\section{Key Points}
\begin{itemize}
    \item Lorem ipsum dolor sit amet, consectetur adipiscing elit.
    \item Vivamus lacinia odio vitae vestibulum vestibulum.
    \item Cras venenatis euismod malesuada.
    \item Nulla facilisi. Phasellus in felis eu sapien cursus vestibulum.
    \item Sed ut perspiciatis unde omnis iste natus error sit voluptatem.
\end{itemize}

\end{document}
EOF
)

codeTemplate=$(cat << EOF
\documentclass[12pt]{article}

\usepackage[spanish]{babel}
\usepackage[utf8]{inputenc}
\usepackage{geometry}
\usepackage{listings}
\usepackage{xcolor}
\usepackage{fancyhdr}
\usepackage{amsmath}
\usepackage{amssymb}

\definecolor{KEYWORDS}{HTML}{0000ff}
\definecolor{COMMENTS}{HTML}{888888}
\definecolor{STRINGS}{HTML}{ff0000}

\lstset{
	frame=shadowbox,
	language=c++,
	aboveskip=3mm,
	belowskip=3mm,
	xleftmargin=10mm,
	xrightmargin=10mm,
	showstringspaces=false,
	columns=flexible,
	basicstyle={\small\ttfamily},
	numbers=left,
	numberstyle=\tiny\color{COMMENTS},
	keywordstyle=\color{KEYWORDS},
	commentstyle=\color{COMMENTS},
	stringstyle=\color{STRINGS},
	breaklines=true,
	breakatwhitespace=true,
	tabsize=4
}

\geometry{
  a4paper,
  left=25mm,
  right=25mm,
  top=25mm,
  bottom=25mm
}

\title{DOCUMENT_TITLE}
\author{AUTHOR}
\date{\today}

\begin{document}

\section{Basic Function Example}
The following code demonstrates a basic function in C++ that calculates the factorial of a number.

\begin{lstlisting}[language=C++, caption=Factorial Function, label=code:factorial]
#include <iostream>

int factorial(int n) {
    if (n <= 1) return 1;
    else return n * factorial(n - 1);
}

int main() {
    int number = 5;
    std::cout << "Factorial of " << number << " is " << factorial(number) << std::endl;
    return 0;
}
\end{lstlisting}

\section{Mathematical Operations}
\subsection{Continuous Mathematics}
The following is an example of a mathematical operation, specifically the quadratic formula:

\[
x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
\]

\subsection{Discrete Mathematics}
An important concept in discrete mathematics is the use of quantifiers. The universal quantifier (\(\forall\)) and the existential quantifier (\(\exists\)) are used to express statements involving all elements or some elements of a set, respectively. For example:

\[
\forall x \in \mathbb{N}, \; P(x) \implies Q(x)
\]

\[
\exists y \in \mathbb{N}, \; P(y) \land Q(y)
\]

Logical connectives such as conjunction (\(\land\)) and disjunction (\(\lor\)) are also commonly used:

\[
P(x) \land Q(x)
\]

\[
P(x) \lor Q(x)
\]

\end{document}
EOF
)
