@ocaml.doc(`
## Stats are used to represent increasing or decreasing trend for data metrics

### some visual representations of statbox

`)
module Example = {
  @react.component
  let make = () => {
    <CF_Col gap=4>
      <CF_Row>
        <CF_StatBox
          input={{
            header: "Stat Heading",
            trend: Increasing,
            totalVolume: "1000",
            changeInVolume: "10",
          }}
          chartType=Half
        />
        <CF_StatBox
          input={{
            header: "Stat Heading",
            trend: Decreasing,
            totalVolume: "1000",
            changeInVolume: "10",
          }}
          chartType=Half
        />
      </CF_Row>
      <CF_Row>
        <CF_StatBox
          input={{
            header: "Stat Heading",
            trend: Increasing,
            totalVolume: "1000",
            changeInVolume: "10",
          }}
          chartType=Full
        />
        <CF_StatBox
          input={{
            header: "Stat Heading",
            trend: Decreasing,
            totalVolume: "1000",
            changeInVolume: "10",
          }}
          chartType=Full
        />
      </CF_Row>
    </CF_Col>
  }
}
