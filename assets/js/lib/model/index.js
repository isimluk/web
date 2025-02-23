export const EXPECT = 'expect';
export const EXPECT_SAME = 'expect_same';

export const TARGET_HOST = 'host';
export const TARGET_CLUSTER = 'cluster';

export const targetTypes = [TARGET_HOST, TARGET_CLUSTER];
export const isValidTargetType = (targetType) =>
  targetTypes.includes(targetType);

export const AWS_PROVIDER = 'aws';
export const AZURE_PROVIDER = 'azure';
export const GCP_PROVIDER = 'gcp';
export const NUTANIX_PROVIDER = 'nutanix';
export const KVM_PROVIDER = 'kvm';
export const VMWARE_PROVIDER = 'vmware';
export const UNKNOWN_PROVIDER = 'unknown';

export const providers = [
  AWS_PROVIDER,
  AZURE_PROVIDER,
  GCP_PROVIDER,
  NUTANIX_PROVIDER,
  KVM_PROVIDER,
  VMWARE_PROVIDER,
];
export const isValidProvider = (provider) => providers.includes(provider);
