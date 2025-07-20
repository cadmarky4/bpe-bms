<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class BlotterCase extends Model
{
    use HasUuids, SoftDeletes;

    protected $table = 'blotters';
    
    protected $keyType = 'string';
    public $incrementing = false;

    protected $fillable = [
        'incident_type',
        'incident_date', 
        'incident_time',
        'location',
        'complainant_id',
        'respondent_info',
        'description',
        'status',
        'assigned_officer',
        'created_by',
        'updated_by'
    ];

    protected $casts = [
        'incident_date' => 'date',
        'incident_time' => 'datetime',
    ];

    protected $dates = ['deleted_at'];

    protected $appends = [
        'case_number',
        'status_display'
    ];

    /**
     * Get the complainant (resident)
     */
    public function complainant(): BelongsTo
    {
        return $this->belongsTo(Resident::class, 'complainant_id');
    }

    /**
     * Get the assigned officer (user)
     */
    public function assignedOfficer(): BelongsTo
    {
        return $this->belongsTo(User::class, 'assigned_officer');
    }

    /**
     * Get the user who created this record
     */
    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Generate case number based on ID and date
     */
    public function getCaseNumberAttribute(): string
    {
        $year = $this->created_at?->format('Y') ?? date('Y');
        $sequence = str_pad(substr($this->id, 0, 4), 4, '0', STR_PAD_LEFT);
        return "BC-{$year}-{$sequence}";
    }

    /**
     * Get formatted status display
     */
    public function getStatusDisplayAttribute(): string
    {
        $statusMap = [
            'PENDING' => 'Pending Investigation',
            'UNDER_INVESTIGATION' => 'Under Investigation',
            'RESOLVED' => 'Resolved',
            'DISMISSED' => 'Dismissed',
            'REFERRED' => 'Referred to Higher Authority',
            'CLOSED' => 'Closed'
        ];

        return $statusMap[$this->status] ?? ucfirst(strtolower($this->status));
    }

    /**
     * Scope for active cases
     */
    public function scopeActive($query)
    {
        return $query->whereNotIn('status', ['RESOLVED', 'DISMISSED', 'CLOSED']);
    }

    /**
     * Scope for resolved cases
     */
    public function scopeResolved($query)
    {
        return $query->whereIn('status', ['RESOLVED', 'CLOSED']);
    }

    /**
     * Scope for pending cases
     */
    public function scopePending($query)
    {
        return $query->where('status', 'PENDING');
    }

    /**
     * Scope by incident type
     */
    public function scopeByIncidentType($query, $type)
    {
        return $query->where('incident_type', $type);
    }

    /**
     * Scope for recent cases (last 30 days)
     */
    public function scopeRecent($query)
    {
        return $query->where('created_at', '>=', now()->subDays(30));
    }
}
