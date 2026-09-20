const capabilities = [
  {
    index: "01",
    title: "Compatibility evidence",
    description:
      "Connect hardware revisions, firmware releases, requirements, and validation results into one explainable decision.",
  },
  {
    index: "02",
    title: "Release impact",
    description:
      "Trace transitive dependencies and identify the configurations and devices affected by a proposed release.",
  },
  {
    index: "03",
    title: "Configuration history",
    description:
      "Reconstruct the components and firmware installed on a physical device at any point in its lifecycle.",
  },
];

const signals = [
  ["Validated", "Required evidence passes"],
  ["Incomplete", "Coverage is missing"],
  ["Blocked", "A known condition fails"],
  ["Explainable", "Every decision has evidence"],
];

export default function Home() {
  return (
    <main className="shell">
      <nav className="nav" aria-label="Primary navigation">
        <span className="brand">CompatLab</span>
        <span className="phase">
          <span className="phase-dot" aria-hidden="true" />
          <span>Foundation phase</span>
        </span>
      </nav>

      <section className="hero">
        <p className="eyebrow">Hardware and firmware compatibility intelligence</p>
        <h1>Know what can ship before it reaches a device.</h1>
        <p className="hero-copy">
          CompatLab will connect board revisions, installed components, firmware
          releases, and validation evidence so engineering teams can make
          release decisions they can explain.
        </p>
        <p className="question">
          Which configurations are supported, what evidence proves it, and what
          would be affected if this release shipped?
        </p>
      </section>

      <section aria-labelledby="capabilities-heading">
        <div className="section-heading">
          <h2 id="capabilities-heading">Planned capabilities</h2>
          <span>VERSION 1</span>
        </div>
        <div className="capability-grid">
          {capabilities.map((capability) => (
            <article className="capability" key={capability.index}>
              <span className="capability-index">{capability.index}</span>
              <h3>{capability.title}</h3>
              <p>{capability.description}</p>
            </article>
          ))}
        </div>
      </section>

      <section className="signal-row" aria-label="Compatibility states">
        {signals.map(([title, description]) => (
          <div className="signal" key={title}>
            <strong>{title}</strong>
            <span>{description}</span>
          </div>
        ))}
      </section>

      <footer className="footer">
        Independent engineering project by Farbod Alikhanzadeh
      </footer>
    </main>
  );
}
