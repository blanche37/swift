// RUN: %empty-directory(%t)
// RUN: cp -r %S/Inputs/ObjcProperty/ObjcProperty.framework %t
// RUN: %target-swift-frontend(mock-sdk: %clang-importer-sdk) -enable-objc-interop -emit-module -o %t/ObjcProperty.framework/Modules/ObjcProperty.swiftmodule/%target-swiftmodule-name -import-underlying-module -F %t -module-name ObjcProperty -disable-objc-attr-requires-foundation-module %s
// RUN: %target-swift-symbolgraph-extract -sdk %clang-importer-sdk -module-name ObjcProperty -F %t -output-dir %t -pretty-print -v
// RUN: %FileCheck %s --input-file %t/ObjcProperty.symbols.json

// REQUIRES: objc_interop

import Foundation

public enum SwiftEnum {}

// ensure that children of clang nodes appear in the symbol graph

// CHECK: "precise": "c:objc(cs)Foo(py)today"

// ensure that implicit/inherited clang symbols (i.e. inherited constructors/properties in objc) are
// given synthesized USRs that don't conflict with their parent symbol

// CHECK-LABEL:  "relationships"
// CHECK:            "kind": "overrides"
// CHECK-NEXT:       "source": "c:objc(cs)NSObject(im)init::SYNTHESIZED::c:objc(cs)Foo"
// CHECK-NEXT:       "target": "c:objc(cs)NSObject(im)init"
// CHECK-NEXT:       "targetFallback": "ObjectiveC.NSObject.init()"
// CHECK-NEXT:       "sourceOrigin": {
// CHECK-NEXT:         "identifier": "c:objc(cs)NSObject(im)init"
// CHECK-NEXT:         "displayName": "Foo.init()"
// CHECK-NEXT:       }
