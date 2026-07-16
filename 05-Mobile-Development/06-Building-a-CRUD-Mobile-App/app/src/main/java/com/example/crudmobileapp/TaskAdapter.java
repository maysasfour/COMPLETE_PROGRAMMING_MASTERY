package com.example.crudmobileapp;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.List;

public class TaskAdapter extends RecyclerView.Adapter<TaskAdapter.ViewHolder> {
    public interface OnDeleteListener {
        void onDelete(Task task, int position);
    }

    private final List<Task> tasks;
    private final OnDeleteListener onDeleteListener;

    public TaskAdapter(List<Task> tasks, OnDeleteListener onDeleteListener) {
        this.tasks = tasks;
        this.onDeleteListener = onDeleteListener;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_task, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Task task = tasks.get(position);
        holder.taskText.setText(task.name);
        holder.deleteButton.setOnClickListener(v -> onDeleteListener.onDelete(task, holder.getBindingAdapterPosition()));
        holder.deleteButton.post(() -> {
            int[] location = new int[2];
            holder.deleteButton.getLocationOnScreen(location);
            Log.d("CrudMobileDemo", "deleteButton[" + task.name + "] real screen center: (" +
                    (location[0] + holder.deleteButton.getWidth() / 2) + ", " +
                    (location[1] + holder.deleteButton.getHeight() / 2) + ")");
        });
    }

    @Override
    public int getItemCount() {
        return tasks.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        final TextView taskText;
        final Button deleteButton;
        ViewHolder(View itemView) {
            super(itemView);
            taskText = itemView.findViewById(R.id.taskText);
            deleteButton = itemView.findViewById(R.id.deleteButton);
        }
    }
}
