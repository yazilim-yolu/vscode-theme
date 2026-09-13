/**
 * TypeScript — tema testi.
 * JSDoc bloğu, `@param` gibi etiketler ve satır içi `kod` burada görünür.
 */

/// <reference lib="esnext" />

import { readFile, writeFile as save } from "node:fs/promises";
import type { Buffer } from "node:buffer";
import * as path from "node:path";

export const VERSION = "0.2.1" as const;
export let counter: number = 0;
var legacyFlag = false;

declare global {
  interface Window {
    __YAZILIM_YOLU__?: Readonly<Record<string, unknown>>;
  }
}

export namespace Geometry {
  export const TAU = Math.PI * 2;
}

export enum Level {
  Debug = 0,
  Info = 1,
  Warn = 2,
  Error = 3,
}

export const enum Direction {
  North = "N",
  South = "S",
}

export type Nullable<T> = T | null | undefined;
export type Keys<T extends object> = keyof T;
export type Unwrap<T> = T extends Promise<infer U> ? U : never;
export type Handler = (event: string, ...rest: readonly unknown[]) => void;

export interface Repository<T extends { id: string }> {
  readonly name: string;
  find(id: string): Promise<Nullable<T>>;
  all?(): Iterable<T>;
  new (seed: number): Repository<T>;
  [key: string]: unknown;
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}

function assertDefined<T>(value: T, label: string): asserts value is NonNullable<T> {
  if (value === undefined || value === null) {
    throw new TypeError(`${label} tanımsız`);
  }
}

export abstract class Component<P = {}> {
  protected static instances = 0;
  public readonly id: string;
  private _props: P;
  #secret = Symbol("secret");

  public constructor(props: P) {
    this.id = `c${++Component.instances}`;
    this._props = props;
  }

  public get props(): P {
    return this._props;
  }

  public set props(next: P) {
    this._props = { ...this._props, ...next };
  }

  protected abstract render(): string;

  public toString(): string {
    return `<${this.constructor.name} id=${this.id}>`;
  }
}

export class Panel extends Component<{ title: string }> implements Disposable {
  static override readonly kind = "panel";
  accessor visible = true;

  constructor(title: string) {
    super({ title });
  }

  protected override render(): string {
    return this.props.title.toUpperCase();
  }

  [Symbol.dispose](): void {
    this.visible = false;
  }
}

export async function* walk(dir: string, depth = 0): AsyncGenerator<string, void, undefined> {
  const entries = await readFile(dir, { encoding: "utf8" });
  for (const line of entries.split(/\r?\n/g)) {
    if (!line) continue;
    yield path.join(dir, line);
    yield* walk(line, depth + 1);
  }
}

export default async function main(argv: string[] = process.argv): Promise<number> {
  using panel = new Panel("Yazılım Yolu");
  const levels = [Level.Debug, Level.Info, Level.Warn] satisfies Level[];
  const raw = 0b1010 + 0o777 + 0xff + 1_000_000 + 3.14e-2 + 42n;

  label: for (let i = 0; i < levels.length; i++) {
    switch (levels[i]) {
      case Level.Debug:
      case Level.Info: {
        legacyFlag = true;
        break;
      }
      case Level.Warn:
        continue label;
      default:
        break label;
    }
  }

  do {
    counter += 1;
  } while (counter < 3);

  while (counter > 0) counter--;

  try {
    assertDefined(argv[0], "argv[0]");
    const data = await Promise.all([readFile("a.json"), readFile("b.json")]);
    const parsed = data.map((buf: Buffer) => JSON.parse(buf.toString()) as unknown);
    if (parsed.every(isRecord)) await save("out.json", JSON.stringify(parsed, null, 2));
  } catch (error) {
    if (error instanceof Error) console.error(error.message, error.stack);
    throw error;
  } finally {
    delete (globalThis as { __tmp__?: number }).__tmp__;
  }

  const tag = String.raw`satır\nkaçmaz`;
  const greeting = `merhaba ${panel.props.title.padEnd(10, "·")} — ${raw}`;
  const optional = window?.__YAZILIM_YOLU__?.["theme"] ?? "yazilim-yolu-dark";

  console.log(greeting, tag, optional, typeof optional, "x" in globalThis, void 0);
  return counter === 0 ? 0 : 1;
}

export { main as run };
export * from "./sample.js";
