//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArgumentParser
import DestinationsGenerator
import FileUtils

@main
struct Main: AsyncParsableCommand {
  @Flag(help: "Avoid delegating to Docker for copying destination toolchain and SDK files.")
  var withoutDocker: Bool = false

  @Flag(
    help: "Avoid cleaning up toolchain and SDK directories and regenerate an SDK bundle incrementally."
  )
  var incremental: Bool = false

  mutating func run() async throws {
    let elapsed = try await ContinuousClock().measure {
      try await LocalFileSystem().generateDestinationBundle(
        shouldUseDocker: !withoutDocker,
        shouldGenerateFromScratch: !incremental
      )
    }

    print("\nTime taken for this generator run: \(elapsed.formatted())")
  }
}
