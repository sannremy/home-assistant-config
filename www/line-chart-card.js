class LineChartCard extends HTMLElement {
  // Whenever the state changes, a new `hass` object is set. Use this to
  // update your content.
  set hass(hass) {
    // Initialize the content if it's not there yet.
    if (!this.content) {
      this.innerHTML = `
        <ha-card header="${this.config.title || 'Line Chart Card'}">
          <div class="card-content">
            <canvas></canvas>
          </div>
        </ha-card>
      `;
      this.content = this.querySelector("div");
      this.canvas = this.querySelector("canvas");
    }

    const entityId = this.config.entity;
    // const state = hass.states[entityId];
    // const stateStr = state ? state.state : "unavailable";

    // this.content.innerHTML = `
    //   The state of ${entityId} is ${stateStr}!
    // `;

    this.chart = new Chart(this.canvas, {
      type: 'line',
      data: {
        labels: Utils.months({count: 7}),
        datasets: [{
          label: entityId,
          data: [65, 59, 80, 81, 56, 55, 40],
          fill: false,
          borderColor: 'rgb(75, 192, 192)',
          tension: 0.1
        }],
      }
    });
  }

  // The user supplied configuration. Throw an exception and Home Assistant
  // will render an error card.
  setConfig(config) {
    if (!config.entity) {
      throw new Error("You need to define an entity");
    }
    this.config = config;
  }

  // The height of your card. Home Assistant uses this to automatically
  // distribute all cards over the available columns in masonry view
  getCardSize() {
    return 3;
  }

  // The rules for sizing your card in the grid in sections view
  getGridOptions() {
    return {
      rows: 3,
      columns: 6,
      min_rows: 3,
      max_rows: 3,
    };
  }
}

customElements.define("line-chart-card", LineChartCard);