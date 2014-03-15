setup(
    name="RepeatSoaker",
    author="Mikhail Dozmorov, Cory Giles",
    author_email="dozmorovm@omrf.org",
    description="Post-process high-throughput sequencing alignments by removing reads falling in repetitive regions.",
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: GNU Affero General Public License v3 or later (AGPLv3+)",
        "Natural Language :: English",
        "Operating System :: POSIX",
        "Programming Language :: Python",
        "Topic :: Scientific/Engineering :: Bio-Informatics"
    ],
    license="AGPLv3+",
    entry_points={
        "console_scripts":
        ["repeat-soaker = RepeatSoaker:main"]
    }
)
