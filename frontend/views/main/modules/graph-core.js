
const GraphCore = {
  chart: null,
  graphData: null,

  init(containerId) {
    const container = document.getElementById(containerId);
    this.chart = echarts.init(container);
    this.renderEmptyChart();

    window.addEventListener('resize', () => {
      this.chart.resize();
    });
  },

  renderEmptyChart() {
    const option = {
      title: {
        text: '请选择行业或生成数据',
        left: 'center',
        top: 'center',
        textStyle: {
          color: '#999',
          fontSize: 16
        }
      },
      series: []
    };
    this.chart.setOption(option);
  },

  renderChart(graphData, nodeClickHandler) {
    this.graphData = graphData;

    if (!graphData || !graphData.nodes || graphData.nodes.length === 0) {
      this.renderEmptyChart();
      return;
    }

    const nodeMap = {};
    graphData.nodes.forEach(node => {
      nodeMap[node.id] = node;
    });

    const categoriesMap = {
      'INDUSTRY': { name: '行业', color: '#5470c6' },
      'COMPANY': { name: '企业', color: '#91cc75' }
    };

    const option = {
      tooltip: {
        trigger: 'item',
        formatter: (params) => {
          if (params.dataType === 'edge') {
            const source = nodeMap[params.data.source];
            const target = nodeMap[params.data.target];
            return `${source?.name || params.data.source} → ${target?.name || params.data.target}<br/>关系：${params.data.relationType || '关联'}`;
          }
          return `${params.data.name}<br/>类型：${params.data.type || '未知'}`;
        }
      },
      series: [{
        type: 'graph',
        layout: 'force',
        data: graphData.nodes.map(node => ({
          id: node.id,
          name: node.name,
          type: node.type,
          symbolSize: node.type === 'INDUSTRY' ? 60 : 40,
          itemStyle: {
            color: categoriesMap[node.type]?.color || '#999'
          }
        })),
        links: (graphData.edges || []).map(edge => ({
          source: edge.sourceNodeId,
          target: edge.targetNodeId,
          relationType: edge.relationType
        })),
        roam: true,
        draggable: true,
        label: {
          show: true,
          position: 'right',
          formatter: '{b}'
        },
        lineStyle: {
          color: 'source',
          curveness: 0.3
        },
        force: {
          repulsion: 300,
          edgeLength: 120
        }
      }]
    };

    this.chart.setOption(option, true);

    this.chart.off('click');
    this.chart.on('click', (params) => {
      if (nodeClickHandler && params.dataType === 'node') {
        nodeClickHandler(params.data);
      }
    });
  },

  zoomIn() {
    this.chart.dispatchAction({ type: 'restore' });
  },

  zoomOut() {
    this.chart.dispatchAction({ type: 'restore' });
  },

  resetZoom() {
    this.chart.dispatchAction({ type: 'restore' });
  },

  resize() {
    this.chart.resize();
  }
};
