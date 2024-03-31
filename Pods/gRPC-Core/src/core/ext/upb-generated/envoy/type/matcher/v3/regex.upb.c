/* This file was generated by upbc (the upb compiler) from the input
 * file:
 *
 *     envoy/type/matcher/v3/regex.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#include <stddef.h>
#include "upb/msg_internal.h"
#include "envoy/type/matcher/v3/regex.upb.h"
#include "google/protobuf/wrappers.upb.h"
#include "envoy/annotations/deprecation.upb.h"
#include "udpa/annotations/status.upb.h"
#include "udpa/annotations/versioning.upb.h"
#include "validate/validate.upb.h"

#include "upb/port_def.inc"

static const upb_MiniTable_Sub envoy_type_matcher_v3_RegexMatcher_submsgs[1] = {
  {.submsg = &envoy_type_matcher_v3_RegexMatcher_GoogleRE2_msginit},
};

static const upb_MiniTable_Field envoy_type_matcher_v3_RegexMatcher__fields[2] = {
  {1, UPB_SIZE(12, 24), UPB_SIZE(-1, -1), 0, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(4, 8), UPB_SIZE(0, 0), kUpb_NoSub, 9, kUpb_FieldMode_Scalar | (kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_type_matcher_v3_RegexMatcher_msginit = {
  &envoy_type_matcher_v3_RegexMatcher_submsgs[0],
  &envoy_type_matcher_v3_RegexMatcher__fields[0],
  UPB_SIZE(16, 32), 2, kUpb_ExtMode_NonExtendable, 2, 255, 0,
};

static const upb_MiniTable_Sub envoy_type_matcher_v3_RegexMatcher_GoogleRE2_submsgs[1] = {
  {.submsg = &google_protobuf_UInt32Value_msginit},
};

static const upb_MiniTable_Field envoy_type_matcher_v3_RegexMatcher_GoogleRE2__fields[1] = {
  {1, UPB_SIZE(4, 8), UPB_SIZE(1, 1), 0, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_type_matcher_v3_RegexMatcher_GoogleRE2_msginit = {
  &envoy_type_matcher_v3_RegexMatcher_GoogleRE2_submsgs[0],
  &envoy_type_matcher_v3_RegexMatcher_GoogleRE2__fields[0],
  UPB_SIZE(8, 16), 1, kUpb_ExtMode_NonExtendable, 1, 255, 0,
};

static const upb_MiniTable_Sub envoy_type_matcher_v3_RegexMatchAndSubstitute_submsgs[1] = {
  {.submsg = &envoy_type_matcher_v3_RegexMatcher_msginit},
};

static const upb_MiniTable_Field envoy_type_matcher_v3_RegexMatchAndSubstitute__fields[2] = {
  {1, UPB_SIZE(4, 8), UPB_SIZE(1, 1), 0, 11, kUpb_FieldMode_Scalar | (kUpb_FieldRep_Pointer << kUpb_FieldRep_Shift)},
  {2, UPB_SIZE(8, 16), UPB_SIZE(0, 0), kUpb_NoSub, 9, kUpb_FieldMode_Scalar | (kUpb_FieldRep_StringView << kUpb_FieldRep_Shift)},
};

const upb_MiniTable envoy_type_matcher_v3_RegexMatchAndSubstitute_msginit = {
  &envoy_type_matcher_v3_RegexMatchAndSubstitute_submsgs[0],
  &envoy_type_matcher_v3_RegexMatchAndSubstitute__fields[0],
  UPB_SIZE(16, 32), 2, kUpb_ExtMode_NonExtendable, 2, 255, 0,
};

static const upb_MiniTable *messages_layout[3] = {
  &envoy_type_matcher_v3_RegexMatcher_msginit,
  &envoy_type_matcher_v3_RegexMatcher_GoogleRE2_msginit,
  &envoy_type_matcher_v3_RegexMatchAndSubstitute_msginit,
};

const upb_MiniTable_File envoy_type_matcher_v3_regex_proto_upb_file_layout = {
  messages_layout,
  NULL,
  NULL,
  3,
  0,
  0,
};

#include "upb/port_undef.inc"
