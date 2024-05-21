module Example = {
  @react.component
  let make = () => {
    <CF_BreadCrumb
      elements={[
        {state: #inactive, element: "Element 1"},
        {state: #inactive, element: "Element 2"},
        {state: #active, element: "Element 3"},
      ]}
    />
  }
}
