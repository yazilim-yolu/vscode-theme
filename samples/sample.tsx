import React, { useCallback, useEffect, useMemo, useReducer, useRef, useState } from "react";
import type { FC, PropsWithChildren, ReactNode } from "react";

type Status = "idle" | "loading" | "ready" | "error";

interface Task {
  readonly id: number;
  title: string;
  done: boolean;
  tags: string[];
}

interface BoardProps {
  title: string;
  initial?: readonly Task[];
  onChange?: (tasks: readonly Task[]) => void;
  renderEmpty?: () => ReactNode;
}

type Action =
  | { type: "add"; payload: Task }
  | { type: "toggle"; payload: number }
  | { type: "clear" };

function reducer(state: Task[], action: Action): Task[] {
  switch (action.type) {
    case "add":
      return [...state, action.payload];
    case "toggle":
      return state.map((t) => (t.id === action.payload ? { ...t, done: !t.done } : t));
    case "clear":
      return [];
    default: {
      const never: never = action;
      throw new Error(`bilinmeyen eylem: ${JSON.stringify(never)}`);
    }
  }
}

const Badge: FC<PropsWithChildren<{ tone?: "mor" | "turkuaz" }>> = ({ tone = "mor", children }) => (
  <span className={`badge badge--${tone}`} data-tone={tone}>
    {children}
  </span>
);

export const Board: FC<BoardProps> = ({ title, initial = [], onChange, renderEmpty }) => {
  const [tasks, dispatch] = useReducer(reducer, initial as Task[]);
  const [status, setStatus] = useState<Status>("idle");
  const [query, setQuery] = useState("");
  const inputRef = useRef<HTMLInputElement | null>(null);

  const visible = useMemo(
    () => tasks.filter(({ title: t }) => t.toLocaleLowerCase("tr").includes(query.trim())),
    [tasks, query],
  );

  const handleAdd = useCallback(
    (event: React.FormEvent<HTMLFormElement>): void => {
      event.preventDefault();
      const value = inputRef.current?.value ?? "";
      if (!value) return;
      dispatch({ type: "add", payload: { id: Date.now(), title: value, done: false, tags: ["yeni"] } });
      inputRef.current!.value = "";
    },
    [dispatch],
  );

  useEffect(() => {
    setStatus("loading");
    const timer = setTimeout(() => setStatus(tasks.length ? "ready" : "idle"), 250);
    onChange?.(tasks);
    return () => clearTimeout(timer);
  }, [tasks, onChange]);

  return (
    <section className="board" aria-label={title} data-status={status}>
      <header style={{ display: "flex", gap: 8, alignItems: "center" }}>
        <h2 className="board__title">{title}</h2>
        <Badge tone="turkuaz">{visible.length}</Badge>
      </header>

      <form onSubmit={handleAdd}>
        <input ref={inputRef} type="text" placeholder="Görev ekle…" required maxLength={120} />
        <input value={query} onChange={(e) => setQuery(e.target.value)} aria-label="Ara" />
        <button type="submit" disabled={status === "loading"}>
          Ekle
        </button>
      </form>

      {visible.length === 0 ? (
        (renderEmpty?.() ?? <p className="empty">Henüz görev yok.</p>)
      ) : (
        <ul>
          {visible.map((task) => (
            <li key={task.id} className={task.done ? "done" : undefined}>
              <label>
                <input
                  type="checkbox"
                  checked={task.done}
                  onChange={() => dispatch({ type: "toggle", payload: task.id })}
                />
                {task.title}
              </label>
              {task.tags.map((tag) => (
                <Badge key={tag}>#{tag}</Badge>
              ))}
            </li>
          ))}
        </ul>
      )}

      <>
        <hr />
        {/* JSX yorumu */}
        <small>Toplam {tasks.length} kayıt</small>
      </>
    </section>
  );
};

export default Board;
