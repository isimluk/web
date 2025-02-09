export const HANA_SCALE_UP = 'hana_scale_up';
export const HANA_SCALE_OUT = 'hana_scale_out';
export const ASCS_ERS = 'ascs_ers';

export const clusterTypes = [HANA_SCALE_UP, HANA_SCALE_OUT, ASCS_ERS];

export const isValidClusterType = (clusterType) =>
  clusterTypes.includes(clusterType);

const clusterTypeLabels = {
  [HANA_SCALE_UP]: 'HANA Scale Up',
  [HANA_SCALE_OUT]: 'HANA Scale Out',
  [ASCS_ERS]: 'ASCS/ERS',
};

export const getClusterTypeLabel = (type) =>
  clusterTypeLabels[type] || 'Unknown';
