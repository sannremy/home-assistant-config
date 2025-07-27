class ChartCard extends HTMLElement {
  // Whenever the state changes, a new `hass` object is set. Use this to
  // update your content.
  set hass(hass) {
    // Initialize the content if it's not there yet.
    if (!this.content) {
      this.innerHTML = `
        <ha-card header="${this.config.title || 'Chart Card'}">
          <div class="card-content">
            <canvas></canvas>
          </div>
        </ha-card>
      `;
      this.content = this.querySelector("div");
      this.canvas = this.querySelector("canvas");
    }

    const datasets = hass.states[this.config.entity]?.attributes?.chart_datasets || [];

    if (Chart && datasets.length > 0) {
      this.chart?.destroy();
      this.chart = new Chart(this.canvas, {
        data: {
          datasets: datasets.map(dataset => ({
            type: 'line', // Default to line if type is not specified
            label: 'Dataset',
            data: [],
            ...dataset
          })),
        },
        options: {
          scales: {
            x: {
              type: 'time',
              time: {
                unit: 'day', // Adjust the time unit as needed
                tooltipFormat: 'MMM D, YYYY',
                displayFormats: {
                  day: 'MMM D',
                },
              },
              title: {
                display: true,
                text: 'Date',
              },
            },
          },
        }
      });
    } else {
      this.content.innerHTML = `No data available for entity ${this.config.entity}. Please ensure it has the correct attributes.`;
    }
  }

  // The user supplied configuration. Throw an exception and Home Assistant
  // will render an error card.
  setConfig(config) {
    if (!config.entity) {
      throw new Error("You need to define an entity.");
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

customElements.define("chart-card", ChartCard);