// metapp library
// 
// Copyright (C) 2022 Wang Qi (wqking)
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//   http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef METAPP_VARIANT_METATYPE_H_969872685611
#define METAPP_VARIANT_METATYPE_H_969872685611

#include "metapp/metatype.h"

namespace metapp {

template <>
struct DeclareMetaTypeBase <Variant>
{
	static constexpr TypeKind typeKind = tkVariant;

	static bool cast(Variant * result, const Variant * fromVar, const MetaType * toMetaType) {
		if(commonCast(result, fromVar, getMetaType<Variant>(), toMetaType)) {
			return true;
		}
		else {
			if(fromVar != nullptr) {
				const Variant & ref = fromVar->get<const Variant &>();
				Variant casted = ref.castSilently(toMetaType);
				if(casted.isEmpty()) {
					return false;
				}
				if(result != nullptr) {
					*result = std::move(casted);
				}
			}
			return true;
		}
	}

	static bool castFrom(Variant * result, const Variant * fromVar, const MetaType * /*fromMetaType*/)
	{
		if(result != nullptr) {
			*result = *fromVar;
		}
		return true;
	}

};


} // namespace metapp


#endif
